# frozen_string_literal: true

module Queries
  class ProductsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ProductType], null: false

    def resolve(search:)
      products = Product.order(:name)
      products = products.name_contains(search) unless search.blank?
      products
    end
  end

  class ProductQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::ProductType, null: true

    def resolve(slug:)
      Product.find_by(slug:)
    end
  end

  class EndorsersQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::EndorserType], null: false

    def resolve(search:)
      endorsers = Endorser.order(:name)
      endorsers = endorsers.name_contains(search) unless search.blank?
      endorsers
    end
  end

  class ProductRepositoriesQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type [Types::ProductRepositoryType], null: false

    def resolve(slug:)
      product = Product.find_by(slug:)

      product_repositories = []
      unless product.nil?
        product_repositories = ProductRepository.where(product_id: product.id, deleted: false)
                                                .order(main_repository: :desc)
      end
      product_repositories
    end
  end

  class ProductRepositoryQuery < Queries::BaseQuery
    argument :slug, String, required: true
    argument :product_slug, String, required: false, default_value: ''
    type Types::ProductRepositoryType, null: true

    def resolve(slug:, product_slug:)
      product_repository = ProductRepository.where(slug:)
      unless product_slug.nil?
        product = Product.find_by(slug: product_slug)
        product_repository = product_repository.where(
          product_id: product.id,
          deleted: false
        ) unless product.nil?
      end
      product_repository.first
    end
  end

  class OwnedProductsQuery < Queries::BaseQuery
    type [Types::ProductType], null: false

    def resolve
      product_ids = context[:current_user].user_products.map(&:to_s) \
        unless context[:current_user].nil?
      owned_products = Product.where('id in (?)', product_ids)
      owned_products
    end
  end

  class CompareProductsQuery < Queries::BaseQuery
    argument :slugs, [String], required: true

    type GraphQL::Types::JSON, null: false

    def calculate_intersections(intersections, key, current_product)
      value = current_product[key]
      if intersections.key?(key)
        if intersections[key].is_a?(Array)
          intersections[key] = intersections[key] & value
        else
          intersections[key] = nil unless intersections[key] == value
        end
      else
        intersections[key] = value
      end
    end

    def resolve(slugs:)
      compared_products = {}

      products = []
      intersections = {}
      Product.where(slug: slugs).each do |product|
        current_product = {}
        current_product['name'] = product.name
        current_product['slug'] = product.slug
        current_product['website'] = product.website
        current_product['imageFile'] = product.image_file
        current_product['ui.product.rubric.label'] = product.maturity_score_details

        current_product['ui.sector.label'] =
          product.sectors
                 .where(locale: I18n.locale)
                 .sort_by(&:name)
                 .map(&:name)
        calculate_intersections(intersections, 'ui.sector.label', current_product)

        current_product['ui.buildingBlock.label'] =
          product.building_blocks
                 .sort_by(&:name)
                 .map { |b| b.name.to_s + (b.category == 'DPI' ? " [DPI]" : '') }
        calculate_intersections(intersections, 'ui.buildingBlock.label', current_product)

        current_product['ui.sdg.label'] =
          product.sustainable_development_goals
                 .sort_by(&:number)
                 .map { |sdg| "#{sdg.number}. #{sdg.name}" }
        calculate_intersections(intersections, 'ui.sdg.label', current_product)

        current_product['ui.product.project.count'] = product.projects.count
        calculate_intersections(intersections, 'ui.product.project.count', current_product)

        if product.commercial_product
          current_product['product.license'] = 'Commercial'
        elsif !product.main_repository.nil?
          current_product['product.license'] = product.main_repository.license
        else
          current_product['product.license'] = 'N/A'
        end
        calculate_intersections(intersections, 'product.license', current_product)

        product_use_cases = []
        product.use_case_steps.each do |use_case_step|
          product_use_cases << use_case_step.use_case
        end
        current_product['ui.useCase.label'] =
          product_use_cases.sort_by(&:name)
                           .map(&:name)
                           .uniq
        calculate_intersections(intersections, 'ui.useCase.label', current_product)

        products << current_product
      end
      compared_products['products'] = products
      compared_products['intersections'] = intersections
      compared_products
    end
  end
end
