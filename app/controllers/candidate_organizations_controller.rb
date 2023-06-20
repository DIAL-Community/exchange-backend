# frozen_string_literal: true

class CandidateOrganizationsController < ApplicationController
  acts_as_token_authentication_handler_for User, only: %i[approve reject]
  skip_before_action :verify_authenticity_token, if: :json_request

  before_action :authenticate_user!, only: %i[approve reject]

  def json_request
    request.format.json?
  end

  def approve
    set_candidate_organization
    authorize(@candidate_organization, :mod_allowed?)

    organization = Organization.new
    organization.name = @candidate_organization.name
    organization.website = @candidate_organization.website

    organization.slug = @candidate_organization.slug

    duplicates = Organization.where(slug: organization.slug)
    if duplicates.count.positive?
      first_duplicate = Organization.slug_starts_with(organization.slug).order(slug: :desc).first
      organization.slug = organization.slug + generate_offset(first_duplicate).to_s
    end

    organization.contacts += @candidate_organization.contacts

    respond_to do |format|
      # Don't re-approve approved candidate.
      if (@candidate_organization.rejected.nil? || @candidate_organization.rejected) &&
         organization.save && @candidate_organization.update(rejected: false, approved_date: Time.now,
                                                             approved_by_id: current_user.id)

        candidate_organization_contact, _rest = @candidate_organization.contacts
        if !candidate_organization_contact.nil? && !candidate_organization_contact.email.nil?
          AdminMailer
            .with(rejected: false, user_email: candidate_organization_contact.email)
            .notify_candidate_organization_approval
            .deliver_now
        end

        format.html { redirect_to(organization_url(organization), notice: 'Candidate promoted to organization.') }
        format.json { render(json: { message: 'Candidate approved.' }, status: :ok) }
      else
        format.html { redirect_to(candidate_organizations_url, flash: { error: 'Unable to approve candidate.' }) }
        format.json { render(json: { message: 'Candidate approval failed.' }, status: :bad_request) }
      end
    end
  end

  def reject
    set_candidate_organization
    authorize(@candidate_organization, :mod_allowed?)
    respond_to do |format|
      # Can only approve new submission.
      if @candidate_organization.rejected.nil? &&
         @candidate_organization.update(rejected: true, rejected_date: Time.now, rejected_by_id: current_user.id)

        candidate_organization_contact, _rest = @candidate_organization.contacts
        if !candidate_organization_contact.nil? && !candidate_organization_contact.email.nil?
          AdminMailer
            .with(rejected: true, user_email: candidate_organization_contact.email)
            .notify_candidate_organization_approval
            .deliver_now
        end

        format.html { redirect_to(candidate_organizations_url, notice: 'Candidate rejected.') }
        format.json { render(json: { message: 'Candidate declined.' }, status: :ok) }
      else
        format.html { redirect_to(candidate_organizations_url, flash: { error: 'Unable to reject candidate.' }) }
        format.json { render(json: { message: 'Declining candidate failed' }, status: :bad_request) }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_candidate_organization
    @candidate_organization = CandidateOrganization.find_by(slug: params[:id])
    if @candidate_organization.nil? && params[:id].scan(/\D/).empty?
      @candidate_organization = CandidateOrganization.find(params[:id])
    end
  end
end
