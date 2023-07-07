# frozen_string_literal: true

module Paginated
  class PaginationAttributeBuildingBlock < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sdgs, [String], required: false, default_value: []
    argument :use_cases, [String], required: false, default_value: []
    argument :workflows, [String], required: false, default_value: []
    argument :category_types, [String], required: false, default_value: []
    argument :show_mature, Boolean, required: false, default_value: false

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, sdgs:, use_cases:, workflows:, category_types:, show_mature:)
      building_blocks = BuildingBlock.order(:name)
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
        use_case_ids.concat(sdg_use_cases.ids)
      end

      workflow_ids = []
      filtered_use_cases = use_case_ids.concat(use_cases.reject { |x| x.nil? || x.empty? })
      unless filtered_use_cases.empty?
        filtered = true
        use_case_workflows = Workflow.joins(:use_case_steps)
                                     .where(use_case_steps: { use_case_id: filtered_use_cases })
        workflow_ids.concat(use_case_workflows.ids)
      end

      filtered_workflows = workflows.reject { |x| x.nil? || x.empty? }
      filtered ||= !filtered_workflows.empty?

      filtered_workflows = workflow_ids.concat(filtered_workflows)
      if filtered
        if filtered_workflows.empty?
          return []
        else
          building_blocks = building_blocks.joins(:workflows)
                                           .where(workflows: { id: filtered_workflows })
        end
      end

      published_building_block = BuildingBlock.entity_status_types[:PUBLISHED]
      building_blocks = building_blocks.where(maturity: published_building_block) if show_mature

      building_blocks = building_blocks.where(category: category_types) unless category_types.empty?

      { total_count: building_blocks.count }
    end
  end
end
