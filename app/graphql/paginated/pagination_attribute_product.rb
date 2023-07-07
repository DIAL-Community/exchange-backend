# frozen_string_literal: true

module Paginated
  class PaginationAttributeProduct < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :origins, [String], required: false, default_value: []
    argument :sectors, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []
    argument :license_types, [String], required: false, default_value: []

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, origins:, sectors:, tags:, license_types:)
      products = Product.order(:name)
      if !search.nil? && !search.to_s.strip.empty?
        name_products = products.name_contains(search)
        desc_products = products.joins(:product_descriptions)
                                .where('LOWER(description) like LOWER(?)', "%#{search}%")
        alias_products = products.where("LOWER(array_to_string(aliases,',')) like LOWER(?)", "%#{search}%")
        sector_products = products.joins(:sectors)
                                  .where('LOWER(sectors.name) LIKE LOWER(?)', "%#{search}%")

        products = products.where(id: (name_products + desc_products + alias_products + sector_products).uniq)
      end

      filtered_origins = origins.reject { |x| x.nil? || x.empty? }
      unless filtered_origins.empty?
        products = products.joins(:origins)
                           .where(origins: { id: filtered_origins })
      end

      filtered_sectors = []
      user_sectors = sectors.reject { |x| x.nil? || x.empty? }
      user_sectors.each do |user_sector|
        if user_sector.scan(/\D/).empty?
          sector = Sector.find_by(id: user_sector)
        else
          sector = Sector.find_by(name: user_sector)
        end
        next if sector.nil?

        filtered_sectors << sector.id
      end
      unless filtered_sectors.empty?
        products = products.joins(:sectors)
                           .where(sectors: { id: filtered_sectors })
      end

      filtered_tags = tags.reject { |x| x.nil? || x.blank? }
      unless filtered_tags.empty?
        products = products.where(
          "tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or " \
          "tags @> '{#{filtered_tags.join(',')}}'::varchar[]"
        )
      end

      if (license_types - ['oss_only']).empty? && (['oss_only'] - license_types).empty?
        products = products.where(commercial_product: false)
      elsif (license_types - ['commercial_only']).empty? && (['commercial_only'] - license_types).empty?
        products = products.where(commercial_product: true)
      end

      { total_count: products.count }
    end
  end
end
