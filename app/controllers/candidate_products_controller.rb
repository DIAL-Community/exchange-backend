# frozen_string_literal: true

class CandidateProductsController < ApplicationController
  acts_as_token_authentication_handler_for User, only: %i[approve reject]
  skip_before_action :verify_authenticity_token, if: :json_request
  before_action :authenticate_user!, only: %i[approve reject]

  def json_request
    request.format.json?
  end

  def approve
    set_candidate_product
    authorize(@candidate_product, :mod_allowed?)

    product = Product.new
    product.name = @candidate_product.name.to_s.strip
    product.website = @candidate_product.website
    product.commercial_product = @candidate_product.commercial_product

    product.slug = @candidate_product.slug

    duplicates = Product.where(slug: product.slug)
    if duplicates.count.positive?
      first_duplicate = Product.slug_starts_with(product.slug).order(slug: :desc).first
      product.slug = product.slug + generate_offset(first_duplicate).to_s
    end

    respond_to do |format|
      # Don't re-approve approved candidate.
      if (@candidate_product.rejected.nil? || @candidate_product.rejected) &&
         product.save && @candidate_product.update(rejected: false, approved_date: Time.now,
                                                   approved_by_id: current_user.id)

        unless @candidate_product.repository.nil?
          product_repository = ProductRepository.new
          product_repository.name = "#{@candidate_product.name} Repository"
          product_repository.slug = slug_em(product_repository.name)

          product_repositorys = ProductRepository.where(slug: product_repository.slug)
          unless product_repositorys.empty?
            first_duplicate = ProductRepository.slug_starts_with(product_repository.slug)
                                               .order(slug: :desc).first
            product_repository.slug = product_repository.slug + generate_offset(first_duplicate).to_s
          end

          product_repository.absolute_url = @candidate_product.repository
          product_repository.description = "Default repository for #{@candidate_product.name}."
          product_repository.main_repository = true
          product_repository.product = product

          if product_repository.save!
            logger.info("Created repository for: #{@candidate_product.name}.")
          end
        end

        AdminMailer
          .with(rejected: false, user_email: @candidate_product.submitter_email)
          .notify_candidate_product_approval
          .deliver_now

        format.html { redirect_to(product_url(product), notice: 'Candidate promoted to product.') }
        format.json { render(json: { message: 'Candidate product approved.' }, status: :ok) }
      else
        format.html { redirect_to(candidate_products_url, flash: { error: 'Unable to approve candidate.' }) }
        format.json { render(json: { message: 'Candidate approval failed.' }, status: :bad_request) }
      end
    end
  end

  def reject
    set_candidate_product
    authorize(@candidate_product, :mod_allowed?)
    respond_to do |format|
      # Can only approve new submission.
      if @candidate_product.rejected.nil? &&
         @candidate_product.update(rejected: true, rejected_date: Time.now, rejected_by_id: current_user.id)

        AdminMailer
          .with(rejected: true, user_email: @candidate_product.submitter_email)
          .notify_candidate_product_approval
          .deliver_now

        format.html { redirect_to(candidate_products_url, notice: 'Candidate declined.') }
        format.json { render(json: { message: 'Candidate product declined.' }, status: :ok) }
      else
        format.html { redirect_to(candidate_products_url, flash: { error: 'Unable to reject candidate.' }) }
        format.json { render(json: { message: 'Declining candidate failed.' }, status: :bad_request) }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_candidate_product
    @candidate_product = CandidateProduct.find_by(slug: params[:id])
    @candidate_product = CandidateProduct.find(params[:id]) if @candidate_product.nil? && params[:id].scan(/\D/).empty?
  end
end
