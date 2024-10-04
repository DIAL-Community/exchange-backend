# frozen_string_literal: true

module Paginated
  class PaginationAttributeProduct < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :countries, [String], required: false, default_value: []
    argument :use_cases, [String], required: false, default_value: []
    argument :building_blocks, [String], required: false, default_value: []
    argument :sectors, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []
    argument :license_types, [String], required: false, default_value: []
    argument :workflows, [String], required: false, default_value: []
    argument :sdgs, [String], required: false, default_value: []
    argument :origins, [String], required: false, default_value: []
    argument :software_categories, [String], required: false, default_value: []
    argument :software_features, [String], required: false, default_value: []
    argument :product_stages, [String], required: false, default_value: nil

    argument :is_linked_with_dpi, Boolean, required: false, default_value: false
    # Show only flagged gov_stack_entity. Query: gov_stack_entity = true if show_gov_stack_only is true.
    argument :show_gov_stack_only, Boolean, required: false, default_value: false
    # Show only origins = 'dpga' if show_dpga_only is true.
    argument :show_dpga_only, Boolean, required: false, default_value: false
    argument :featured, Boolean, required: false, default_value: nil

    type Attributes::PaginationAttributes, null: false

    def filter_building_blocks(sdgs, use_cases, workflows, building_blocks, is_linked_with_dpi)
      filtered = false

      use_case_ids = []
      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      unless filtered_sdgs.empty?
        filtered = true
        sdg_numbers = SustainableDevelopmentGoal.where(id: filtered_sdgs)
                                                .select(:number)
        sdg_use_cases = UseCase.joins(:sdg_targets)
                               .where(sdg_targets: { sdg_number: sdg_numbers })
        use_case_ids += sdg_use_cases.ids unless sdg_use_cases.empty?
      end

      workflow_ids = []
      filtered_use_cases = use_case_ids + use_cases.reject { |x| x.nil? || x.empty? }
      unless filtered_use_cases.empty?
        filtered = true
        use_case_workflows = Workflow.joins(:use_case_steps)
                                     .where(use_case_steps: { use_case_id: filtered_use_cases.map(&:to_i) })
        workflow_ids += use_case_workflows.ids unless use_case_workflows.empty?
      end

      building_block_ids = []
      filtered_workflows = workflow_ids + workflows.reject { |x| x.nil? || x.empty? }
      unless filtered_workflows.empty?
        filtered = true
        workflow_building_blocks = BuildingBlock.joins(:workflows)
                                                .where(workflows: { id: filtered_workflows.map(&:to_i) })
        building_block_ids += workflow_building_blocks.ids unless workflow_building_blocks.empty?
      end

      filtered_bbs = building_blocks.reject { |x| x.nil? || x.empty? }
      unless filtered_bbs.empty?
        filtered = true
        building_block_ids += filtered_bbs.map(&:to_i)
      end

      if is_linked_with_dpi
        filtered = true
        dpi_building_block = BuildingBlock.category_types[:DPI]
        dpi_building_blocks = BuildingBlock.where(category: dpi_building_block)
        unless building_block_ids.empty?
          dpi_building_blocks = dpi_building_blocks.where(id: building_block_ids)
        end
        building_block_ids = dpi_building_blocks.map(&:id)
      end

      [filtered, building_block_ids]
    end

    def resolve(
      search:, countries:, use_cases:, building_blocks:, sectors:, tags:, license_types:,
      workflows:, sdgs:, origins:, is_linked_with_dpi:, show_gov_stack_only:, show_dpga_only:,
      product_stages:, software_categories:, software_features:, featured:
    )
      if !unsecure_read_allowed && context[:current_user].nil?
        return { total_count: 0 }
      end

      products = Product.order(:name).distinct

      products = products.where(featured:) unless featured.nil? || featured == false

      if product_stages.present? && product_stages.any?
        products = products.where(product_stage: product_stages)
      end

      filtered, filtered_building_blocks = filter_building_blocks(
        sdgs, use_cases, workflows, building_blocks, is_linked_with_dpi
      )
      if filtered
        if filtered_building_blocks.empty?
          # Filter is active, but all the filters are resulting in empty building block array.
          # All bb is filtered out, return no product.
          return { total_count: 0 }
        else
          products = products.joins(:building_blocks)
                             .where(building_blocks: { id: filtered_building_blocks })
        end
      end

      if !search.nil? && !search.to_s.strip.empty?
        name_products = products.name_contains(search)
        desc_products = products.joins(:product_descriptions)
                                .where('LOWER(product_descriptions.description) like LOWER(?)', "%#{search}%")
        alias_products = products.where("LOWER(array_to_string(aliases,',')) like LOWER(?)", "%#{search}%")
        sector_products = products.joins(:sectors)
                                  .where('LOWER(sectors.name) LIKE LOWER(?)', "%#{search}%")

        products = products.where(id: (name_products + desc_products + alias_products + sector_products).uniq)
      end

      if show_dpga_only
        products = products.joins(:origins)
                           .where(origins: { slug: 'dpga' })

        products = products.left_outer_joins(:endorsers)
                           .where.not(endorsers: { id: nil })
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        products = products.joins(:countries)
                           .where(countries: { id: filtered_countries })
      end

      filtered_origins = origins.reject { |x| x.nil? || x.empty? }
      unless filtered_origins.empty?
        products = products.joins(:origins)
                           .where(origins: { id: filtered_origins })
      end

      filtered_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        products = products.joins(:sectors)
                           .where(sectors: { id: filtered_sectors })
      end

      filtered_categories = software_categories.reject { |x| x.nil? || x.empty? }
      unless filtered_categories.empty?
        products = products.joins(:software_categories)
                           .where(software_categories: { id: filtered_categories })
      end

      filtered_features = software_features.reject { |x| x.nil? || x.empty? }
      unless filtered_features.empty?
        products = products.joins(:software_features)
                           .where(software_features: { id: filtered_features })
      end

      filtered_tags = tags.reject { |x| x.nil? || x.blank? }
      unless filtered_tags.empty?
        products = products.where(
          "products.tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or " \
          "products.tags @> '{#{filtered_tags.join(',')}}'::varchar[]"
        )
      end

      if (license_types - ['oss_only']).empty? && (['oss_only'] - license_types).empty?
        products = products.where(commercial_product: false)
      elsif (license_types - ['commercial_only']).empty? && (['commercial_only'] - license_types).empty?
        products = products.where(commercial_product: true)
      end

      products = products.where(gov_stack_entity: show_gov_stack_only) if show_gov_stack_only

      { total_count: products.distinct.count }
    end
  end
end
