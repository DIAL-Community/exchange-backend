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
end
