# frozen_string_literal: true

module Queries
  class ProductQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::ProductType, null: true

    def resolve(slug:)
      product = Product.find_by(slug:) if valid_slug?(slug)
      validate_access_to_instance(product || Product.new)
      product
    end
  end

  class ProductsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ProductType], null: false

    def resolve(search:)
      validate_access_to_resource(Product.new)
      products = Product.order(:name)
      products = products.name_contains(search) unless search.blank?
      products
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
      current_value = current_product[key]
      if intersections.key?(key)
        if intersections[key].is_a?(Array)
          intersections[key] = intersections[key] & current_value
        else
          intersections[key] = nil unless intersections[key] == current_value
        end
      else
        intersections[key] = current_value
      end
    end

    def calculate_similarities(similarities, key, current_product)
      current_value = current_product[key]
      if similarities.key?(key)
        similarity = similarities[key]
        # Don't need to compare as the field is different already
        return if similarity[:different]

        # Field is still the same (or only contains the first value)
        existing_value = similarities[key][:current]
        if existing_value.is_a?(Array)
          # (A-B).blank? && (B-A).blank? to check 2 arrays equality
          similarities[key][:different] =
            (current_value - existing_value).blank? &&
            (existing_value - current_value).blank?
        else
          similarities[key][:different] = current_value.to_s == existing_value.to_s
        end
        similarities[key][:current] = current_value
      else
        # Initial value, not different and keep the current product field's value
        similarities[key] = {
          'different': false,
          'current': current_value
        }
      end
    end

    def resolve(slugs:)
      compared_products = {}

      products = []

      similarities = {}
      intersections = {}
      Product.where(slug: slugs).order(:slug).each do |product|
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
        calculate_similarities(similarities, 'ui.sector.label', current_product)
        calculate_intersections(intersections, 'ui.sector.label', current_product)

        current_product['ui.buildingBlock.label'] =
          product.building_blocks
                 .sort_by(&:name)
                 .map { |b| b.name.to_s + (b.category == 'DPI' ? " [DPI]" : '') }
        calculate_similarities(similarities, 'ui.buildingBlock.label', current_product)
        calculate_intersections(intersections, 'ui.buildingBlock.label', current_product)

        current_product['ui.sdg.label'] =
          product.sustainable_development_goals
                 .sort_by(&:number)
                 .map { |sdg| "#{sdg.number}. #{sdg.name}" }
        calculate_similarities(similarities, 'ui.sdg.label', current_product)
        calculate_intersections(intersections, 'ui.sdg.label', current_product)

        current_product['ui.product.project.count'] = product.projects.count
        calculate_similarities(similarities, 'ui.product.project.count', current_product)
        calculate_intersections(intersections, 'ui.product.project.count', current_product)

        if product.commercial_product
          current_product['product.license'] = 'Commercial'
        elsif !product.main_repository.nil?
          current_product['product.license'] = product.main_repository.license
        else
          current_product['product.license'] = 'N/A'
        end
        calculate_similarities(similarities, 'product.license', current_product)
        calculate_intersections(intersections, 'product.license', current_product)

        product_use_cases = []
        product.use_case_steps.each do |use_case_step|
          product_use_cases << use_case_step.use_case
        end
        current_product['ui.useCase.label'] =
          product_use_cases.sort_by(&:name)
                           .map(&:name)
                           .uniq
        calculate_similarities(similarities, 'ui.useCase.label', current_product)
        calculate_intersections(intersections, 'ui.useCase.label', current_product)

        products << current_product
      end
      compared_products['products'] = products
      compared_products['intersections'] = intersections
      compared_products['similarities'] = similarities.map { |k, v| [k, v[:different]] }.to_h
      compared_products
    end
  end

  def filter_products(search, countries, products)
    products = Product.all
    if !search.nil? && !search.to_s.strip.empty?
      name_products = products.name_contains(search)
      desc_products = products.joins(:product_descriptions)
                              .where('LOWER(description) like LOWER(?)', "%#{search}%")
      products = products.where(id: (name_products + desc_products).uniq)
    end

    filtered_countries = countries.reject { |x| x.nil? || x.empty? }
    unless filtered_countries.empty?
      products = products.left_joins(:countries, :products)
                         .where(countries: { id: filtered_countries })
                         .or(products.left_joins(:countries, :products)
                         .where(products: { id: Product.joins(:countries)
                         .where(countries: { id: filtered_countries }) }))
    end

    filtered_products = products.reject { |x| x.nil? || x.empty? }
    unless filtered_products.empty?
      products = products.where(products: { id: filtered_products })
    end

    products = products.order(:name)
    products
  end

  class SearchProductsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper
    include Queries

    argument :search, String, required: false, default_value: ''
    argument :countries, [String], required: false, default_value: []
    argument :products, [String], required: false, default_value: []

    type Types::ProductType.connection_type, null: false

    def resolve(search:, countries:, products:)
      products = filter_products(search, countries, products)
      products = products.eager_load(:countries).uniq
      products
    end
  end
end
