# frozen_string_literal: true

require 'modules/wizard_helpers'

module Queries
  include Modules::WizardHelpers

  class ProjectQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::ProjectType, null: true

    def resolve(slug:)
      project = Project.find_by(slug:) if valid_slug?(slug)
      validate_access_to_instance(project || Project.new)
      project
    end
  end

  class ProjectsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ProjectType], null: false

    def resolve(search:)
      validate_access_to_resource(Project.new)
      projects = Project.order(:name)
      projects = projects.name_contains(search) unless search.blank?
      projects
    end
  end

  class SearchProjectsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []
    argument :products, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []

    type [Types::ProjectType], null: false

    def resolve(search:, sectors:, products:, tags:)
      projects = filter_projects(search, sectors, products, tags)
      projects = projects.eager_load(:countries).uniq
      projects
    end

    def filter_projects(search, sectors, products, tags)
      projects = Project.all
      if !search.nil? && !search.to_s.strip.empty?
        name_projects = projects.name_contains(search)
        desc_projects = projects.joins(:project_descriptions)
                                .where('LOWER(description) like LOWER(?)', "%#{search}%")
        projects = projects.where(id: (name_projects + desc_projects).uniq)
      end

      filtered_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        projects = projects.left_joins(:sectors, :products)
                           .where(sectors: { id: filtered_sectors })
                           .or(projects.left_joins(:sectors, :products)
                           .where(products: { id: Product.joins(:sectors)
                           .where(sectors: { id: filtered_sectors }) }))
      end

      filtered_products = products.reject { |x| x.nil? || x.empty? }
      unless filtered_products.empty?
        projects = projects.joins(:products)
                           .where(products: { id: filtered_products })
      end

      filtered_tags = tags.reject { |x| x.nil? || x.blank? }
      unless filtered_tags.empty?
        projects = projects.where(
          "tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or " \
          "tags @> '{#{filtered_tags.join(',')}}'::varchar[]"
        )
      end
      projects = projects.order(:name)
      projects
    end
  end
end
