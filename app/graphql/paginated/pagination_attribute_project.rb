# frozen_string_literal: true

module Paginated
  class PaginationAttributeProject < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :countries, [String], required: false, default_value: []
    argument :products, [String], required: false, default_value: []
    argument :organizations, [String], required: false, default_value: []
    argument :sectors, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []
    argument :sdgs, [String], required: false, default_value: []
    argument :origins, [String], required: false, default_value: []

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, countries:, products:, organizations:, sectors:, tags:, sdgs:, origins:)
      projects = Project.all
      if !search.nil? && !search.to_s.strip.empty?
        name_projects = projects.name_contains(search)
        desc_projects = projects.joins(:project_descriptions)
                                .where('LOWER(description) like LOWER(?)', "%#{search}%")
        projects = projects.where(id: (name_projects + desc_projects).uniq)
      end

      filtered_origins = origins.reject { |x| x.nil? || x.empty? }
      projects = projects.where(origin_id: filtered_origins) unless filtered_origins.empty?

      filtered_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        projects = projects.left_joins(:sectors, :products)
                           .where(sectors: { id: filtered_sectors })
                           .or(projects.left_joins(:sectors, :products)
                           .where(products: { id: Product.joins(:sectors)
                           .where(sectors: { id: filtered_sectors }) }))
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        projects = projects.joins(:countries)
                           .where(countries: { id: filtered_countries })
      end

      filtered_organizations = organizations.reject { |x| x.nil? || x.empty? }
      unless filtered_organizations.empty?
        projects = projects.joins(:organizations)
                           .where(organizations: { id: filtered_organizations })
      end

      filtered_products = products.reject { |x| x.nil? || x.empty? }
      unless filtered_products.empty?
        projects = projects.joins(:products)
                           .where(products: { id: filtered_products })
      end

      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      unless filtered_sdgs.empty?
        projects = projects.joins(:sustainable_development_goals)
                           .where(sustainable_development_goals: { id: filtered_sdgs })
      end

      filtered_tags = tags.reject { |x| x.nil? || x.blank? }
      unless filtered_tags.empty?
        projects = projects.where(
          "projects.tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or " \
          "projects.tags @> '{#{filtered_tags.join(',')}}'::varchar[]"
        )
      end

      { total_count: projects.distinct.count }
    end
  end
end
