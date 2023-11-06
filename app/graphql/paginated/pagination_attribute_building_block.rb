# frozen_string_literal: true

module Paginated
  class PaginationAttributeBuildingBlock < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sdgs, [String], required: false, default_value: []
    argument :use_cases, [String], required: false, default_value: []
    argument :workflows, [String], required: false, default_value: []
    argument :category_types, [String], required: false, default_value: []
    argument :filter_blocks, [String], required: false, default_value: []

    argument :show_mature, Boolean, required: false, default_value: false
    # Show only flagged govstack_entity. Query: govstack_entity = true if show_gov_stack_only is true.
    argument :show_gov_stack_only, Boolean, required: false, default_value: false

    type Attributes::PaginationAttributes, null: false

    def resolve(
      search:, sdgs:, use_cases:, workflows:, category_types:, filter_blocks:,
      show_mature:, show_gov_stack_only:
    )
      building_blocks = BuildingBlock.order(:name).distinct if filter_blocks.empty?
      building_blocks = BuildingBlock.where(id: filter_blocks) if filter_blocks.any?

      unless search.blank?
        name_bbs = building_blocks.name_contains(search)
        desc_bbs = building_blocks.joins(:building_block_descriptions)
                                  .where('LOWER(building_block_descriptions.description) like LOWER(?)', "%#{search}%")
        building_blocks = building_blocks.where(id: (name_bbs + desc_bbs).uniq)
      end

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
                                     .where(use_case_steps: { use_case_id: filtered_use_cases })
        workflow_ids += use_case_workflows.ids unless use_case_workflows.empty?
      end

      filtered_workflows = workflows.reject { |x| x.nil? || x.empty? }
      filtered ||= !filtered_workflows.empty?

      filtered_workflows = workflow_ids + filtered_workflows
      if filtered
        if filtered_workflows.empty?
          return { total_count: 0 }
        else
          building_blocks = building_blocks.joins(:workflows)
                                           .where(workflows: { id: filtered_workflows })
        end
      end

      published_building_block = BuildingBlock.entity_status_types[:PUBLISHED]
      building_blocks = building_blocks.where(maturity: published_building_block) if show_mature
      building_blocks = building_blocks.where(govstack_entity: show_gov_stack_only) if show_gov_stack_only

      building_blocks = building_blocks.where(category: category_types) unless category_types.empty?

      { total_count: building_blocks.distinct.count }
    end
  end
end
