# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class UpdateCandidateProductStatus < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :description, String, required: false
    argument :candidate_status_slug, String, required: true

    field :candidate_product, Types::CandidateProductType, null: true
    field :errors, [String], null: true

    def resolve(slug:, description: nil, candidate_status_slug:)
      candidate_product = CandidateProduct.find_by(slug:)
      candidate_product_policy = Pundit.policy(context[:current_user], candidate_product || CandidateProduct.new)
      unless candidate_product_policy.edit_allowed?
        return {
          candidate_product: nil,
          errors: ['Editing candidate product is not allowed.']
        }
      end

      unless candidate_product.rejected.nil?
        return {
          candidate_product: nil,
          errors: ['Candidate product has already been processed.']
        }
      end

      candidate_status = CandidateStatus.find_by(slug: candidate_status_slug)
      if candidate_product.nil?
        return {
          candidate_product: nil,
          errors: ['Invalid candidate status value.']
        }
      end

      previous_candidate_status = candidate_product.candidate_status

      status_transition_allowed =
        previous_candidate_status.nil? ||
        previous_candidate_status.next_candidate_statuses.include?(candidate_status)
      unless status_transition_allowed
        return {
          candidate_product: nil,
          errors: ['Invalid status transition.']
        }
      end

      current_candidate_status_name = candidate_status.name
      previous_candidate_status_name = previous_candidate_status&.name || 'Candidate Information Received'

      status_transition_text = <<-TRANSITION_TEXT
        <div class='flex flex-row gap-2 my-3'>
          <div class='font-semibold'>
            #{previous_candidate_status_name}
          </div>
          <div class='font-semibold'>
            →
          </div>
          <div class='font-semibold'>
            #{current_candidate_status_name}
          </div>
        </div>
      TRANSITION_TEXT

      unless description.nil?
        status_transition_text += description
      end

      candidate_product.candidate_status = candidate_status

      successful_operation = false
      ActiveRecord::Base.transaction do
        candidate_product.save!

        current_user = context[:current_user]
        comment = Comment.new(
          text: status_transition_text,
          comment_id: SecureRandom.uuid,
          comment_object_id: candidate_product.id,
          comment_object_type: 'CANDIDATE_PRODUCT',
          author: {
            id: current_user.id,
            username: current_user.username
          }
        )
        comment.save!

        # TODO: This need to be moved to settings table.
        if candidate_status.terminal_status
          if candidate_status.name.include?('Reject')
            reject_candidate(candidate_product)
          elsif candidate_status.name.include?('Deny')
            reject_candidate(candidate_product)
          elsif candidate_status.name.include?('Denied')
            reject_candidate(candidate_product)
          elsif candidate_status.name.include?('Approve')
            approve_candidate(candidate_product)
          end
        end

        destination_email_addresses = [candidate_product.submitter_email]

        destination_email_addresses.each do |destination_email_address|
          CandidateMailer
            .with(
              current_candidate: candidate_product,
              current_user: User.find_by(email: destination_email_address),
              sender_email: 'no-reply@exchange.com',
              current_status: current_candidate_status_name,
              previous_status: previous_candidate_status_name,
              destination_email: destination_email_address,
              notification_template: candidate_status.notification_template,
            )
            .notify_candidate_status_update
            .deliver_now
        end

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          candidate_product:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          candidate_product: nil,
          errors: candidate_product.errors.full_messages
        }
      end
    end

    def reject_candidate(candidate_product)
      candidate_product.rejected = true
      candidate_product.rejected_date = Time.now
      candidate_product.rejected_by_id = context[:current_user].id
      candidate_product.save!
    end

    def approve_candidate(candidate_product)
      candidate_product.rejected = false
      candidate_product.approved_date = Time.now
      candidate_product.approved_by_id = context[:current_user].id

      product = Product.new
      product.name = candidate_product.name
      product.slug = reslug_em(candidate_product.name)

      product.approval_status = candidate_product.candidate_status

      product.website = candidate_product.website
      product.commercial_product = candidate_product.commercial_product

      # Check if we need to add _dup to the slug.
      first_duplicate = Product.slug_simple_starts_with(product.slug)
                               .order(slug: :desc).first
      unless first_duplicate.nil?
        product.slug += generate_offset(first_duplicate)
      end

      assign_auditable_user(product)
      product.save!

      unless candidate_product.repository.nil?
        product_description = ProductDescription.find_by(product_id: product.id, locale: I18n.locale)
        product_description = ProductDescription.new if product_description.nil?
        product_description.description = candidate_product.description
        product_description.product_id = product.id
        product_description.locale = I18n.locale

        assign_auditable_user(product_description)
        product_description.save!
      end

      unless candidate_product.repository.nil?
        product_repository = ProductRepository.new
        product_repository.name = "#{candidate_product.name} Repository"
        product_repository.slug = reslug_em(product_repository.name)

        product_repositories = ProductRepository.where(slug: product_repository.slug)
        unless product_repositories.empty?
          first_duplicate = ProductRepository.slug_starts_with(product_repository.slug)
                                             .order(slug: :desc).first
          product_repository.slug += generate_offset(first_duplicate)
        end

        product_repository.absolute_url = candidate_product.repository
        product_repository.description = "Default repository for #{candidate_product.name}."
        product_repository.main_repository = true
        product_repository.product = product

        product_repository.save!
      end

      candidate_product.save!
    end
  end
end
