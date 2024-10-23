# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class ApproveRejectCandidateOrganization < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :action, String, required: true

    field :candidate_organization, Types::CandidateOrganizationType, null: true
    field :errors, [String], null: true

    def resolve(slug:, action:)
      candidate_organization = CandidateOrganization.find_by(slug:)
      candidate_organization_policy = Pundit.policy(
        context[:current_user],
        candidate_organization || CandidateOrganization.new
      )
      unless candidate_organization_policy.edit_allowed?
        return {
          candidate_organization: nil,
          errors: ['Editing candidate organization is not allowed.']
        }
      end

      if action == 'APPROVE'
        successful_operation = approve_candidate(candidate_organization)
      elsif action == 'REJECT'
        successful_operation = reject_candidate(candidate_organization)
      else
        return {
          candidate_organization: nil,
          errors: ['Wrong action provided']
        }
      end

      if successful_operation
        candidate_contact, _rest = candidate_organization.contacts
        unless candidate_contact.nil?
          AdminMailer
            .with(
              rejected: action == 'REJECT',
              object_type: 'Candidate Organization',
              user_email: candidate_contact.email
            )
            .notify_candidate_record_approval
            .deliver_now
        end

        # Successful creation, return the created object with no errors
        {
          candidate_organization:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          candidate_organization: nil,
          errors: candidate_organization.errors.full_messages
        }
      end
    end

    def reject_candidate(candidate_organization)
      candidate_organization.rejected = true
      candidate_organization.rejected_date = Time.now
      candidate_organization.rejected_by_id = context[:current_user].id

      successful_operation = false
      ActiveRecord::Base.transaction do
        candidate_organization.save!
        successful_operation = true
      end

      successful_operation
    end

    def approve_candidate(candidate_organization)
      candidate_organization.rejected = false
      candidate_organization.approved_date = Time.now
      candidate_organization.approved_by_id = context[:current_user].id

      organization = Organization.new(
        name: candidate_organization.name,
        website: candidate_organization.website,
        has_storefront: candidate_organization.create_storefront == true
      )

      candidate_organization.contacts.each do |contact|
        organization.contacts << contact
      end

      slug = reslug_em(candidate_organization.name)
      # Check if we need to add _dup to the slug.
      first_duplicate = Organization.slug_simple_starts_with(slug)
                                    .order(slug: :desc)
                                    .first
      if !first_duplicate.nil?
        organization.slug = slug + generate_offset(first_duplicate)
      else
        organization.slug = slug
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(organization)
        organization.save!

        unless candidate_organization.description.nil?
          organization_description = OrganizationDescription.find_by(
            organization_id: organization.id,
            locale: I18n.locale
          )
          organization_description = OrganizationDescription.new if organization_description.nil?
          organization_description.description = candidate_organization.description
          organization_description.organization_id = organization.id
          organization_description.locale = I18n.locale

          assign_auditable_user(organization_description)
          organization_description.save!
        end

        candidate_organization.save!
        successful_operation = true
      end

      successful_operation
    end
  end
end
