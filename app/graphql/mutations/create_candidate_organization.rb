# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateCandidateOrganization < Mutations::BaseMutation
    include Modules::Slugger

    argument :organization_name, String, required: true
    argument :website, String, required: true
    argument :name, String, required: true
    argument :description, String, required: true
    argument :email, String, required: true
    argument :title, String, required: true
    argument :captcha, String, required: true

    field :candidate_organization, Types::CandidateOrganizationType, null: true
    field :errors, [String], null: true

    def resolve(organization_name:, website:, description:, name:, email:, title:, captcha:)
      candidate_params = { name: organization_name, website:, description: }
      candidate_params[:slug] = slug_em(candidate_params[:name])

      candidate_organizations = CandidateOrganization.where(slug: candidate_params[:slug])
      unless candidate_organizations.empty?
        first_duplicate = CandidateOrganization.slug_simple_starts_with(candidate_params[:slug])
                                               .order(slug: :desc).first
        candidate_params[:slug] = candidate_params[:slug] + generate_offset(first_duplicate).to_s
      end

      candidate_organization = CandidateOrganization.new(candidate_params)

      unless name.blank?
        contact_params = { name:, email:, title: }
        contact_params[:slug] = slug_em(contact_params[:name])

        contacts = Contact.where(slug: contact_params[:slug])
        unless contacts.empty?
          first_duplicate = Contact.slug_simple_starts_with(contact_params[:slug]).order(slug: :desc).first
          contact_params[:slug] = contact_params[:slug] + generate_offset(first_duplicate).to_s
        end
        candidate_organization.contacts << Contact.new(contact_params)
      end

      if candidate_organization.save && captcha_verification(captcha)
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
