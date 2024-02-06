# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateResource < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :phase, String, required: false, default_value: ''
    argument :image_url, String, required: false, default_value: nil
    argument :description, String, required: false, default_value: nil

    argument :image_file, ApolloUploadServer::Upload, required: false
    argument :published_date, GraphQL::Types::ISO8601Date, required: true

    argument :link_description, String, required: false, default_value: nil
    argument :resource_file, ApolloUploadServer::Upload, required: false
    argument :resource_link, String, required: false, default_value: nil

    argument :resource_type, String, required: false, default_value: nil
    argument :resource_topic, String, required: false, default_value: nil
    argument :source, String, required: false, default_value: nil

    argument :authors, [GraphQL::Types::JSON], required: false, default_value: []

    argument :show_in_exchange, Boolean, required: false
    argument :show_in_wizard, Boolean, required: false

    argument :featured, Boolean, required: false

    argument :organization_slug, String, required: false, default_value: nil

    field :resource, Types::ResourceType, null: true
    field :errors, [String], null: true

    def resolve(
      name:, slug:, phase:, image_url:, image_file: nil, description:, published_date:,
      show_in_exchange: false, show_in_wizard: false, featured: false, authors:, organization_slug:,
      resource_file: nil, resource_link:, link_description:, resource_type:, resource_topic:, source:
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
        resource = Resource.new(name:, slug: reslug_em(name))

        # Check if we need to add _dup to the slug.
        first_duplicate = Resource.slug_simple_starts_with(resource.slug)
                                  .order(slug: :desc)
                                  .first
        unless first_duplicate.nil?
          resource.slug += generate_offset(first_duplicate)
        end
      end

      # Update field of the resource object
      resource.name = name
      resource.phase = phase

      resource.resource_link = resource_link
      resource.link_description = link_description
      resource.resource_type = resource_type
      resource.resource_topic = resource_topic
      resource.source = source

      resource.featured = featured

      resource.image_url = image_url
      resource.description = description

      unless published_date.nil?
        date = published_date.to_s
        timestamp = Time.new(date[0..3], date[5..6], date[8..9], 12, 0, 0, "+00:00")
        resource.published_date = timestamp
      end

      resource.show_in_exchange = show_in_exchange
      unless organization.nil?
        # Allow resource coming from
        resource.show_in_exchange = true
      end

      resource.show_in_wizard = show_in_wizard

      successful_operation = false
      ActiveRecord::Base.transaction do
        resource.authors = []
        authors.each do |author|
          resource_author = Author.find_by(name: author['name'])
          resource_author = Author.new if resource_author.nil?

          resource_author.name = author['name']
          resource_author.slug = reslug_em(author['name'])
          resource_author.email = author['email']

          avatar_api = 'https://ui-avatars.com/api/?name='
          avatar_params = '&background=2e3192&color=fff&format=svg'
          resource_author.picture = "#{avatar_api}#{resource_author.name.gsub(/\s+/, '+')}#{avatar_params}"

          resource.authors << resource_author
        end

        assign_auditable_user(resource)
        resource.save!

        unless image_file.nil?
          uploader = SimpleUploader.new(resource, image_file.original_filename, context[:current_user])
          begin
            uploader.store!(image_file)
          rescue StandardError => e
            puts "Unable to save image for: #{resource.name}. Standard error: #{e}."
          end
          resource.auditable_image_changed(image_file.original_filename)
        end

        unless resource_file.nil?
          uploader = FileUploader.new(resource, resource_file.original_filename, context[:current_user])
          begin
            uploader.store!(resource_file)
            # Update resource filename in the database
            resource.resource_filename = uploader.filename
            resource.save!
          rescue StandardError => e
            puts "Unable to resource file for: #{resource.name}. Standard error: #{e}."
          end
        end

        unless organization.nil?
          organization.resources << resource
          organization.save!
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
