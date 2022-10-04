# frozen_string_literal: true

class CandidateRolesController < ApplicationController
  acts_as_token_authentication_handler_for User, only: %i[approve reject]
  skip_before_action :verify_authenticity_token, if: :json_request
  before_action :authenticate_user!, only: %i[approve reject]

  def json_request
    request.format.json?
  end

  def approve
    set_candidate_role
    authorize(@candidate_role, :mod_allowed?)

    user = User.find_by(email: @candidate_role.email)
    if user.nil?
      respond_to do |format|
        format.html { redirect_to(candidate_roles_url, flash: { error: 'Unable to approve request.' }) }
        format.json { head(:no_content) }
      end
    end

    user.roles += @candidate_role.roles

    user.organization_id = @candidate_role.organization_id unless @candidate_role.organization_id.nil?

    unless @candidate_role.product_id.nil?
      product = Product.find_by(id: @candidate_role.product_id)
      user.user_products << product.id unless product.nil? || user.user_products.include?(product.id)
      user.save
    end

    respond_to do |format|
      # Don't re-approve approved candidate.
      format.html { render(nothing: true, status: 200) }
      if (@candidate_role.rejected.nil? || @candidate_role.rejected) &&
               user.save && @candidate_role.update(rejected: false, approved_date: Time.now,
                                                   approved_by_id: current_user.id)
      end
      format.json { render(json: { candidate_role: @candidate_role.id }, status: :ok) }
    end
  end

  def reject
    set_candidate_role
    authorize(@candidate_role, :mod_allowed?)
    respond_to do |format|
      # Can only approve new submission.
      if @candidate_role.rejected.nil? &&
         @candidate_role.update(rejected: true, rejected_date: Time.now, rejected_by_id: current_user.id)
        format.html { redirect_to(candidate_roles_url, notice: 'Request for elevated role rejected.') }
        format.json { render(:show, status: :ok, location: @candidate_role) }
      else
        format.html { redirect_to(candidate_roles_url, flash: { error: 'Unable to reject request.' }) }
        format.json { head(:no_content) }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_candidate_role
    @candidate_role = CandidateRole.find(params[:id])
  end
end
