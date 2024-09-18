# frozen_string_literal: true

class CandidateOrganizationsController < ApplicationController
  acts_as_token_authentication_handler_for User, only: %i[approve reject]
  skip_before_action :verify_authenticity_token, if: :json_request

  before_action :authenticate_user!, only: %i[approve reject]

  def json_request
    request.format.json?
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
