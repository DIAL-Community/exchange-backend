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
    argument :is_mni, Boolean, required: false
    argument :description, String, required: false
    argument :image_file, ApolloUploadServer::Upload, required: false

    argument :has_storefront, Boolean, required: false
    argument :hero_file, ApolloUploadServer::Upload, required: false

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(
      name:, slug:, aliases:, website: nil,
      is_endorser: false, when_endorsed: nil, endorser_level: nil, is_mni: false,
      has_storefront: false, description:, image_file: nil, hero_file: nil
    )
      organization = Organization.find_by(slug:)
      unless an_admin || (an_org_owner(organization.id) unless organization.nil?)
        return {
          organization: nil,
          errors: ['Must be admin or organization owner to create an organization']
        }
      end

      if organization.nil?
        organization = Organization.new(name:)
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
      organization.website = website unless website.nil?
      organization.is_endorser = is_endorser if is_endorser

      unless when_endorsed.nil?
        date = when_endorsed.to_s
        timestamp = Time.new(date[0..3], date[5..6], date[8..9], 12, 0, 0, "+00:00")
        organization.when_endorsed = timestamp
      end

      organization.endorser_level = endorser_level unless endorser_level.nil?
      organization.is_mni = is_mni if is_mni

      organization.has_storefront = has_storefront if has_storefront

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(organization)
        organization.save

        unless image_file.nil?
          uploader = LogoUploader.new(organization, image_file.original_filename, context[:current_user])
          begin
            uploader.store!(image_file)
          rescue StandardError => e
            puts "Unable to save image for: #{organization.name}. Standard error: #{e}."
          end
          organization.auditable_image_changed(image_file.original_filename)
        end

        unless hero_file.nil?
          uploader = HeroUploader.new(organization, "hero_#{hero_file.original_filename}", context[:current_user])
          begin
            uploader.store!(image_file)
          rescue StandardError => e
            puts "Unable to save hero image for: #{organization.name}. Standard error: #{e}."
          end
          organization.auditable_image_changed(image_file.original_filename)
        end

        unless description.nil?
          organization_desc = OrganizationDescription.find_by(organization_id: organization.id, locale: I18n.locale)
          organization_desc = OrganizationDescription.new if organization_desc.nil?
          organization_desc.description = description
          organization_desc.organization_id = organization.id
          organization_desc.locale = I18n.locale
        end

        assign_auditable_user(organization_desc)
        organization_desc.save

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          organization:,
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
