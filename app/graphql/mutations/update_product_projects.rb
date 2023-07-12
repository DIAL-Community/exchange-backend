# frozen_string_literal: true

module Mutations
  class UpdateProductProjects < Mutations::BaseMutation
    argument :project_slugs, [String], required: true
    argument :slug, String, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(project_slugs:, slug:)
      product = Product.find_by(slug:)

      unless an_admin || a_product_owner(product.id)
        return {
          product: nil,
          errors: ['Must be admin or product owner to update a product']
        }
      end

      product.projects = []
      if !project_slugs.nil? && !project_slugs.empty?
        project_slugs.each do |project_slug|
          current_project = Project.find_by(slug: project_slug)
          product.projects << current_project unless current_project.nil?
        end
      end

      if product.save
        # Successful creation, return the created object with no errors
        {
          product:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          product: nil,
          errors: product.errors.full_messages
        }
      end
    end
  end
end
