# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateResource < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :phase, String, required: false, default_value: ''
    argument :image_file, ApolloUploadServer::Upload, required: false

    argument :link, String, required: false, default_value: nil
    argument :image_url, String, required: false, default_value: nil
    argument :description, String, required: false, default_value: nil

    argument :show_in_exchange, Boolean, required: false
    argument :show_in_wizard, Boolean, required: false

    argument :organization_slug, String, required: false, default_value: nil

    field :resource, Types::ResourceType, null: true
    field :errors, [String], null: true

    def resolve(
      name:, slug:, phase:, image_file: nil,
      link:, image_url:, description:,
      show_in_exchange: false, show_in_wizard: false,
      organization_slug:
    )
      unless an_admin || a_content_editor
        return {
          resource: nil,
          errors: ['Must be admin or content editor to create a resource.']
        }
      end

      organization = Organization.find_by(slug: organization_slug)
      if !organization.nil? && an_org_owner(organization.id)
        return {
          resource: nil,
          errors: ['Must be owner of the organization to create resource for it.']
        }
      end

      resource = Resource.find_by(slug:)
      if resource.nil?
        resource = Resource.new(name:, slug: slug_em(name))

        # Check if we need to add _dup to the slug.
        first_duplicate = Resource.slug_simple_starts_with(resource.slug).order(slug: :desc).first
        unless first_duplicate.nil?
          resource.slug += generate_offset(first_duplicate)
        end
      end

      # Update field of the resource object
      resource.name = name
      resource.phase = phase

      resource.link = link
      resource.image_url = image_url
      resource.description = description

      resource.show_in_exchange = show_in_exchange
      unless organization.nil?
        # Allow resource coming from
        resource.show_in_exchange = true
      end

      resource.show_in_wizard = show_in_wizard

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(resource)
        resource.save

        unless image_file.nil?
          uploader = LogoUploader.new(resource, image_file.original_filename, context[:current_user])
          begin
            uploader.store!(image_file)
          rescue StandardError => e
            puts "Unable to save image for: #{resource.name}. Standard error: #{e}."
          end
          resource.auditable_image_changed(image_file.original_filename)
        end

        unless organization.nil?
          organization.resources << resource
          organization.save
        end

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          resource:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          resource: nil,
          errors: resource.errors.full_messages
        }
      end
    end
  end
end
