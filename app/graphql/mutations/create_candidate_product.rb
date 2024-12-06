# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateCandidateProduct < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: false, default_value: ''
    argument :name, String, required: true
    argument :website, String, required: true
    argument :repository, String, required: false
    argument :description, String, required: true
    argument :submitter_email, String, required: true
    argument :commercial_product, Boolean, required: false, default_value: false
    argument :extra_attributes, [Attributes::ExtraAttribute], required: false
    argument :captcha, String, required: true

    field :candidate_product, Types::CandidateProductType, null: true
    field :errors, [String], null: true

    def resolve(
      slug:, name:, website:, repository:, description:, submitter_email:, commercial_product:,
      extra_attributes:, captcha:
    )
      # Find the correct policy
      candidate_product = CandidateProduct.find_by(slug:)
      if !candidate_product.nil? && !candidate_product.rejected.nil?
        return {
          candidate_product: nil,
          errors: ['Attempting to edit rejected or approved candidate product.']
        }
      end

      candidate_product_policy = Pundit.policy(context[:current_user], candidate_product || CandidateProduct.new)
      if candidate_product.nil? && !candidate_product_policy.create_allowed?
        return {
          candidate_dataset: nil,
          errors: ['Creating / editing candidate product is not allowed.']
        }
      end

      if !candidate_product.nil? && !candidate_product_policy.edit_allowed?
        return {
          candidate_product: nil,
          errors: ['Creating / editing candidate product is not allowed.']
        }
      end

      if candidate_product.nil?
        candidate_product = CandidateProduct.new
        # Generate slug for the candidate product.
        slug = reslug_em(name)
        # Check if we need to add _dup to the slug.
        first_duplicate = CandidateProduct.slug_simple_starts_with(slug)
                                          .order(slug: :desc)
                                          .first
        if !first_duplicate.nil?
          candidate_product.slug = slug + generate_offset(first_duplicate)
        else
          candidate_product.slug = slug
        end
      end

      extra_attributes&.each do |attr|
        candidate_product.update_extra_attributes(
          name: attr[:name],
          type: attr[:type],
          value: attr[:value],
          index: attr[:index]
        )
      end

      candidate_product.name = name
      candidate_product.website = website
      candidate_product.repository = repository
      candidate_product.submitter_email = submitter_email
      candidate_product.description = description
      candidate_product.commercial_product = commercial_product

      if candidate_product.save && captcha_verification(captcha)
        AdminMailer
          .with(
            candidate_name: candidate_product.name,
            object_type: 'Candidate Product'
          )
          .notify_new_candidate_record
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
  end
end
