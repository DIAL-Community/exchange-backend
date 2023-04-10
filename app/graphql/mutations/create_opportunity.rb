# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateOpportunity < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :name, String, required: true
    argument :web_address, String, required: false
    argument :description, String, required: true

    argument :contact_name, String, required: true
    argument :contact_email, String, required: true

    argument :opportunity_type, String, required: true
    argument :opportunity_status, String, required: true

    argument :opening_date, GraphQL::Types::ISO8601Date, required: true
    argument :closing_date, GraphQL::Types::ISO8601Date, required: true
    argument :image_file, ApolloUploadServer::Upload, required: false

    field :opportunity, Types::OpportunityType, null: true
    field :errors, [String], null: true

    def resolve(
      name:, slug:, web_address:, description:, contact_name:, contact_email:,
      opportunity_type:, opportunity_status:, opening_date:, closing_date:, image_file: nil
    )
      opportunity = Opportunity.find_by(slug: slug)
      unless an_admin
        return {
          opportunity: nil,
          errors: ['Must be admin to create an opportunity']
        }
      end

      if opportunity.nil?
        opportunity = Opportunity.new(name: name)
        opportunity.slug = slug_em(name)

        if Opportunity.where(slug: slug_em(name)).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Opportunity.slug_simple_starts_with(slug_em(name))
                                       .order(slug: :desc).first
          opportunity.slug = opportunity.slug + generate_offset(first_duplicate)
        end
      end

      # Don'r re-slug opportunity name
      opportunity.name = name
      opportunity.web_address = web_address
      opportunity.description = description

      opportunity.contact_name = contact_name
      opportunity.contact_email = contact_email

      opportunity.opportunity_type = opportunity_type
      opportunity.opportunity_status = opportunity_status

      opportunity.opening_date = opening_date
      opportunity.closing_date = closing_date

      opportunity.origin = Origin.find_by(name: 'Manually Entered')

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(opportunity)
        opportunity.save

        unless image_file.nil?
          uploader = LogoUploader.new(opportunity, image_file.original_filename, context[:current_user])
          begin
            uploader.store!(image_file)
          rescue StandardError => e
            puts "Unable to save image for: #{opportunity.name}. Standard error: #{e}."
          end
          opportunity.auditable_image_changed(image_file.original_filename)
        end

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          opportunity: opportunity,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          opportunity: nil,
          errors: opportunity.errors.full_messages
        }
      end
    end
  end
end
