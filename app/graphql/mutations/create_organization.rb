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
      is_endorser: nil, when_endorsed: nil, endorser_level: nil, is_mni: nil,
      has_storefront: nil, description:, image_file: nil, hero_file: nil
    )
      # Allowed to create record:
      # - Admin user
      # - Non admin user where email host is part of the organization's website

      # Allowed to edit record:
      # - Admin user
      # - Organization owner

      # Case: non user must not be allowed to create / edit storefront.
      current_user = context[:current_user]
      if current_user.nil?
        return {
          organization: nil,
          errors: ['Must be logged in create / edit an organization.']
        }
      end

      # Case: temporary special case for storefronts - want to allow any logged in user to create one
      # Look for an existing org before creating a new one
      if has_storefront
        organization = Organization.first_duplicate(name, slug)
      else
        organization = Organization.find_by(slug:)
        unless an_admin || an_org_owner(organization&.id)
          return {
            organization: nil,
            errors: ['Must be admin or owner to create / edit an organization.']
          }
        end
      end

      creating_record = organization.nil?
      # Case: non admin and non owner user are only allowed creating new storefront, not editing it
      if has_storefront && !an_admin && !an_org_owner(organization&.id)
        unless creating_record
          return {
            organization: nil,
            errors: ["User are not allowed to edit existing organization record."]
          }
        end

        _email_user, email_host = current_user.email.split('@')
        unless website.include?(email_host)
          return {
            organization: nil,
            errors: ["User must have matching email host with organization's website."]
          }
        end
      end

      if organization.nil?
        organization = Organization.new(name:)
        organization.slug = reslug_em(name)

        if Organization.where(slug: organization.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Organization.slug_simple_starts_with(organization.slug)
                                        .order(slug: :desc)
                                        .first
          organization.slug = organization.slug + generate_offset(first_duplicate)
        end
      end

      # Don'r re-slug organization name
      organization.name = name

      organization.aliases = aliases unless aliases.nil?
      organization.website = website unless website.nil?
      organization.is_endorser = is_endorser unless is_endorser.nil?

      unless when_endorsed.nil?
        date = when_endorsed.to_s
        timestamp = Time.new(date[0..3], date[5..6], date[8..9], 12, 0, 0, "+00:00")
        organization.when_endorsed = timestamp
      end

      organization.is_mni = is_mni unless is_mni.nil?
      organization.endorser_level = endorser_level unless endorser_level.nil?

      organization.has_storefront = has_storefront unless has_storefront.nil?

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(organization)
        organization.save

        current_user = context[:current_user]
        # Only assigning ownership when the user is creating organization and not yet owning organization
        if creating_record && has_storefront && !an_admin && !an_org_owner(organization&.id)
          current_user.organization_id = organization.id
          current_user.roles << User.user_roles[:org_user]
          if current_user.save
            puts "Assigning '#{organization.name}' ownership to: '#{current_user.email}'."
          end
        end

        unless image_file.nil?
          uploader = LogoUploader.new(organization, image_file.original_filename, context[:current_user])
          begin
            puts "Saving logo file: '#{uploader.filename}'."
            uploader.store!(image_file)
            puts "Logo image: '#{uploader.filename}' saved."
          rescue StandardError => e
            puts "Unable to save image for: #{organization.name}. Standard error: #{e}."
          end
          organization.auditable_image_changed(image_file.original_filename)
        end

        unless hero_file.nil?
          uploader = HeroUploader.new(organization, "hero_#{hero_file.original_filename}", context[:current_user])
          begin
            puts "Saving hero file: '#{uploader.filename}'."
            uploader.store!(hero_file)
            puts "Hero image: '#{uploader.filename}' saved."
          rescue StandardError => e
            puts "Unable to save hero image for: #{organization.name}. Standard error: #{e}."
          end
          organization.auditable_image_changed(hero_file.original_filename)
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
