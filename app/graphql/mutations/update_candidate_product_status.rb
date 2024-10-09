# frozen_string_literal: true

module Mutations
  class UpdateCandidateProductStatus < Mutations::BaseMutation
    argument :slug, String, required: true
    argument :description, String, required: false
    argument :candidate_status_slug, String, required: true

    field :candidate_product, Types::CandidateProductType, null: true
    field :errors, [String], null: true

    def resolve(slug:, description: nil, candidate_status_slug:)
      candidate_product = CandidateProduct.find_by(slug:)

      unless an_admin
        return {
          candidate_product: nil,
          errors: ['Must be admin to update a candidate product.']
        }
      end

      candidate_status = CandidateStatus.find_by(slug: candidate_status_slug)

      status_transition_text = <<-TRANSITION_TEXT
        <div class='flex flex-row gap-2 my-3'>
          <div class='font-semibold'>
            #{candidate_product.candidate_status&.name || 'Candidate Information Received'}
          </div>
          <div class='font-semibold'>
            →
          </div>
          <div class='font-semibold'>
            #{candidate_status.name}
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
  end
end
