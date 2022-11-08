# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateOrganization < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :aliases, GraphQL::Types::JSON, required: false
    argument :website, String, required: false
    argument :is_endorser, Boolean, required: false, default_value: false
    argument :when_endorsed, GraphQL::Types::ISO8601Date, required: false
    argument :endorser_level, String, required: false
    argument :is_mni, Boolean, required: false, default_value: false
    argument :description, String, required: false
    argument :image_file, ApolloUploadServer::Upload, required: false

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, aliases:, website:, is_endorser:, when_endorsed:, endorser_level:,
      is_mni:, description:, image_file: nil)
      organization = Organization.find_by(slug: slug)

      unless an_admin || (an_org_owner(organization.id) unless organization.nil?)
        return {
          organization: nil,
          errors: ['Must be admin or organization owner to create an organization']
        }
      end

      if organization.nil?
        organization = Organization.new(name: name)
        organization.slug = slug_em(name)

        if Organization.where(slug: slug_em(name)).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Organization.slug_simple_starts_with(slug_em(name))
                                        .order(slug: :desc).first
          organization.slug = organization.slug + generate_offset(first_duplicate)
        end
      end

      # Don'r re-slug organization name
      organization.name = name

      organization.aliases = aliases
      organization.website = website
      organization.is_endorser = is_endorser

      date = when_endorsed.to_s
      timestamp = Time.new(date[0..3], date[5..6], date[8..9], 12, 0, 0, "UTC")
      organization.when_endorsed = timestamp

      organization.endorser_level = endorser_level
      organization.is_mni = is_mni

      if organization.save
        unless image_file.nil?
          uploader = LogoUploader.new(organization, image_file.original_filename, context[:current_user])
          begin
            uploader.store!(image_file)
          rescue StandardError => e
            puts "Unable to save image for: #{organization.name}. Standard error: #{e}."
          end
          organization.auditable_image_changed(image_file.original_filename)
        end

        organization_desc = OrganizationDescription.find_by(organization_id: organization.id, locale: I18n.locale)
        organization_desc = OrganizationDescription.new if organization_desc.nil?
        organization_desc.description = description
        organization_desc.organization_id = organization.id
        organization_desc.locale = I18n.locale
        organization_desc.save

        # Successful creation, return the created object with no errors
        {
          organization: organization,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          organization: nil,
          errors: organization.errors.full_messages
        }
      end
    end
  end
end
