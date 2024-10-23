# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class ApproveRejectCandidateProduct < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :action, String, required: true

    field :candidate_product, Types::CandidateProductType, null: true
    field :errors, [String], null: true

    def resolve(slug:, action:)
      candidate_product = CandidateProduct.find_by(slug:)
      candidate_product_policy = Pundit.policy(
        context[:current_user],
        candidate_product || CandidateProduct.new
      )
      unless candidate_product_policy.edit_allowed?
        return {
          candidate_product: nil,
          errors: ['Editing candidate product is not allowed.']
        }
      end

      if action == 'APPROVE'
        successful_operation = approve_candidate(candidate_product)
      elsif action == 'REJECT'
        successful_operation = reject_candidate(candidate_product)
      else
        return {
          candidate_product: nil,
          errors: ['Wrong action provided']
        }
      end

      if successful_operation
        AdminMailer
          .with(
            rejected: action == 'REJECT',
            object_type: 'Candidate Product',
            user_email: candidate_product.submitter_email
          )
          .notify_candidate_record_approval
          .deliver_now

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

      successful_operation = false
      ActiveRecord::Base.transaction do
        candidate_product.save!
        successful_operation = true
      end

      successful_operation
    end

    def approve_candidate(candidate_product)
      candidate_product.rejected = false
      candidate_product.approved_date = Time.now
      candidate_product.approved_by_id = context[:current_user].id

      product = Product.new(
        name: candidate_product.name,
        website: candidate_product.website,
        commercial_product: candidate_product.commercial_product
      )

      slug = reslug_em(candidate_product.name)
      # Check if we need to add _dup to the slug.
      first_duplicate = Product.slug_simple_starts_with(slug)
                               .order(slug: :desc)
                               .first
      if !first_duplicate.nil?
        product.slug = slug + generate_offset(first_duplicate)
      else
        product.slug = slug
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
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

          product_repositorys = ProductRepository.where(slug: product_repository.slug)
          unless product_repositorys.empty?
            first_duplicate = ProductRepository.slug_starts_with(product_repository.slug)
                                               .order(slug: :desc).first
            product_repository.slug += generate_offset(first_duplicate).to_s
          end

          product_repository.absolute_url = candidate_product.repository
          product_repository.description = "Default repository for #{candidate_product.name}."
          product_repository.main_repository = true
          product_repository.product = product

          product_repository.save!
        end

        candidate_product.save!
        successful_operation = true
      end

      successful_operation
    end
  end
end
