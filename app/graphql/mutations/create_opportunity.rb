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
    argument :opportunity_origin, String, required: true

    argument :opening_date, GraphQL::Types::ISO8601Date, required: false
    argument :closing_date, GraphQL::Types::ISO8601Date, required: true
    argument :image_file, ApolloUploadServer::Upload, required: false, default_value: nil

    argument :gov_stack_entity, Boolean, required: false, default_value: false

    field :opportunity, Types::OpportunityType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, web_address:, description:, contact_name:, contact_email:, opportunity_type:,
      opportunity_status:, opportunity_origin:, opening_date:, closing_date:, image_file:, gov_stack_entity:)
      opportunity = Opportunity.find_by(slug:)
      opportunity_policy = Pundit.policy(context[:current_user], opportunity || Opportunity.new)
      if opportunity.nil? && !opportunity_policy.create_allowed?
        return {
          opportunity: nil,
          errors: ['Creating / editing opportunity is not allowed.']
        }
      end

      if !opportunity.nil? && !opportunity_policy.edit_allowed?
        return {
          opportunity: nil,
          errors: ['Creating / editing opportunity is not allowed.']
        }
      end

      if opportunity.nil?
        opportunity = Opportunity.new(name:)
        opportunity.slug = reslug_em(name)

        if Opportunity.where(slug: opportunity.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Opportunity.slug_simple_starts_with(opportunity.slug)
                                       .order(slug: :desc)
                                       .first
          opportunity.slug += generate_offset(first_duplicate)
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

      opportunity.origin = Origin.find_by(slug: opportunity_origin)

      # Only admin will be allowed to set this flag
      opportunity.gov_stack_entity = gov_stack_entity if an_admin

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(opportunity)
        opportunity.save!

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
          opportunity:,
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
