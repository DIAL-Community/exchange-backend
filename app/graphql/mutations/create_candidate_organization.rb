# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateCandidateOrganization < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: false
    argument :website, String, required: true
    argument :description, String, required: true
    argument :organization_name, String, required: true
    argument :create_storefront, Boolean, required: true
    argument :name, String, required: true
    argument :email, String, required: true
    argument :title, String, required: false
    argument :captcha, String, required: true

    field :candidate_organization, Types::CandidateOrganizationType, null: true
    field :errors, [String], null: true

    def resolve(slug:, organization_name:, create_storefront:, website:, description:, name:, email:, title:, captcha:)
      # Find the correct policy
      candidate_organization = CandidateOrganization.find_by(slug:)
      if !candidate_organization.nil? && !candidate_organization.rejected.nil?
        return {
          candidate_organization: nil,
          errors: ['Attempting to edit rejected or approved candidate organization.']
        }
      end

      candidate_organization_policy = Pundit.policy(
        context[:current_user],
        candidate_organization || CandidateOrganization.new
      )
      if candidate_organization.nil? && !candidate_organization_policy.create_allowed?
        return {
          candidate_organization: nil,
          errors: ['Creating / editing candidate organization is not allowed.']
        }
      end

      if !candidate_organization.nil? && !candidate_organization_policy.edit_allowed?
        return {
          candidate_organization: nil,
          errors: ['Creating / editing candidate organization is not allowed.']
        }
      end

      if candidate_organization.nil?
        candidate_params = { name: organization_name, website:, description: }
        candidate_params[:slug] = reslug_em(candidate_params[:name])

        candidate_organizations = CandidateOrganization.where(slug: candidate_params[:slug])
        unless candidate_organizations.empty?
          first_duplicate = CandidateOrganization.slug_simple_starts_with(candidate_params[:slug])
                                                 .order(slug: :desc)
                                                 .first
          candidate_params[:slug] += generate_offset(first_duplicate).to_s
        end

        candidate_organization = CandidateOrganization.new(candidate_params)
      end

      candidate_organization.name = organization_name
      candidate_organization.website = website
      candidate_organization.description = description
      candidate_organization.create_storefront = create_storefront

      unless name.blank? && email.blank?
        contact_params = { name:, email:, title: }
        contact_params[:slug] = reslug_em(contact_params[:name])

        contact = Contact.find_by(slug: contact_params[:slug])
        contact = Contact.find_by(email: contact_params[:email]) if contact.nil?
        contact = Contact.new(contact_params) if contact.nil?

        contacts = Contact.where(slug: contact_params[:slug])
        unless contacts.empty?
          first_duplicate = Contact.slug_simple_starts_with(contact_params[:slug])
                                   .order(slug: :desc)
                                   .first
          contact_params[:slug] = contact_params[:slug] + generate_offset(first_duplicate).to_s
        end
        candidate_organization.contacts = [contact]
      end

      if candidate_organization.save && captcha_verification(captcha)
        AdminMailer
          .with(
            candidate_name: candidate_organization.name,
            object_type: 'Candidate Organization'
          )
          .notify_new_candidate_record
          .deliver_now
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
  end
end
