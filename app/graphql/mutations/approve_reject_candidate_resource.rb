# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class ApproveRejectCandidateResource < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :action, String, required: true

    field :candidate_resource, Types::CandidateResourceType, null: true
    field :errors, [String], null: true

    def resolve(slug:, action:)
      unless an_admin
        return {
          candidate_resource: nil,
          errors: ['Must be admin to approve or reject candidate resource']
        }
      end

      candidate_resource = CandidateResource.find_by(slug:)

      if action == 'APPROVE'
        successful_operation = approve_candidate(candidate_resource)
      elsif action == 'REJECT'
        successful_operation = reject_candidate(candidate_resource)
      else
        return {
          candidate_resource: nil,
          errors: ['Wrong action provided']
        }
      end

      if successful_operation
        AdminMailer
          .with(
            rejected: action == 'REJECT',
            object_type: 'Candidate Resource',
            user_email: candidate_resource.submitter_email
          )
          .notify_candidate_record_approval
          .deliver_now

        # Successful creation, return the created object with no errors
        {
          candidate_resource:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          candidate_resource: nil,
          errors: candidate_resource.errors.full_messages
        }
      end
    end

    def reject_candidate(candidate_resource)
      candidate_resource.rejected = true
      candidate_resource.rejected_date = Time.now
      candidate_resource.rejected_by_id = context[:current_user].id

      successful_operation = false
      ActiveRecord::Base.transaction do
        candidate_resource.save!
        successful_operation = true
      end

      successful_operation
    end

    def approve_candidate(candidate_resource)
      candidate_resource.rejected = false
      candidate_resource.approved_date = Time.now
      candidate_resource.approved_by_id = context[:current_user].id

      resource = Resource.new(
        name: candidate_resource.name,
        description: candidate_resource.description,
        resource_type: candidate_resource.resource_type,
        resource_link: candidate_resource.resource_link,
        link_description: candidate_resource.link_description,
        published_date: candidate_resource.published_date,
        phase: "Not Applicable"
      )

      resource.countries = []
      country_slugs = candidate_resource.countries.map(&:slug)
      if !country_slugs.nil? && !country_slugs.empty?
        country_slugs.each do |country_slug|
          current_country = Country.find_by(slug: country_slug)
          resource.countries << current_country unless current_country.nil?
        end
      end

      slug = reslug_em(candidate_resource.name)
      # Check if we need to add _dup to the slug.
      first_duplicate = Resource.slug_simple_starts_with(slug)
                                .order(slug: :desc)
                                .first
      if !first_duplicate.nil?
        resource.slug = slug + generate_offset(first_duplicate)
      else
        resource.slug = slug
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(resource)
        resource.save!

        candidate_resource.save!

        successful_operation = true
      end

      successful_operation
    end
  end
end
