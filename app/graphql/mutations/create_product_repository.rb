# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateProductRepository < Mutations::BaseMutation
    include Modules::Slugger

    argument :product_slug, String, required: true

    argument :slug, String, required: true
    argument :name, String, required: true
    argument :absolute_url, String, required: true
    argument :description, String, required: true
    argument :main_repository, Boolean, required: true

    field :product_repository, Types::ProductRepositoryType, null: true
    field :errors, [String], null: true

    def resolve(slug:, product_slug:, name:, absolute_url:, description:, main_repository:)
      product = Product.find_by(slug: product_slug)
      if product.nil? || (!a_product_owner(product.id) && !an_admin)
        return {
          product_repository: nil,
          errors: ['Unable to create product repository object.']
        }
      end

      product_repository = ProductRepository.find_by(slug:)
      if product_repository.nil?
        product_repository = ProductRepository.new(slug: reslug_em(name))

        product_repositories = ProductRepository.where(slug: product_repository.slug)
        unless product_repositories.empty?
          first_duplicate = ProductRepository.slug_simple_starts_with(product_repository.slug)
                                             .order(slug: :desc)
                                             .first
          product_repository.slug += generate_offset(first_duplicate).to_s
        end
      end

      product_repository.name = name
      product_repository.absolute_url = absolute_url
      product_repository.description = description
      product_repository.main_repository = main_repository

      product_repository.product = product

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(product_repository)
        product_repository.save

        product = product_repository.product

        product.manual_update = true
        assign_auditable_user(product)
        product.save

        successful_operation = true
      end

      if successful_operation
        # Successful deletion, return the saved product_repository with no errors
        {
          product_repository:,
          errors: []
        }
      else
        # Failed saving, return the errors to the client
        {
          product_repository: nil,
          errors: product_repository.errors.full_messages
        }
      end
    end
  end
end
