# frozen_string_literal: true

module Mutations
  class UpdateProjectProducts < Mutations::BaseMutation
    argument :product_slugs, [String], required: true
    argument :slug, String, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(product_slugs:, slug:)
      project = Project.find_by(slug:)

      unless an_admin || org_owner_check_for_project(project) ||
        product_owner_check(product_slugs)
        return {
          project: nil,
          errors: ['Must have proper rights to update a project']
        }
      end

      project.products = []
      if !product_slugs.nil? && !product_slugs.empty?
        product_slugs.each do |product_slug|
          current_product = Product.find_by(slug: product_slug)
          unless current_product.nil?
            project.products << current_product
          end
        end
      end

      if project.save
        # Successful creation, return the created object with no errors
        {
          project:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          project: nil,
          errors: project.errors.full_messages
        }
      end
    end

    def product_owner_check(product_slugs)
      product_slugs.each do |slug|
        product = Product.find_by(slug:)
        if a_product_owner(product.id)
          return true
        end
      end
      false
    end
  end
end
