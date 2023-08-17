# frozen_string_literal: true

module Paginated
  class PaginationAttributeWorkflow < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sdgs, [String], required: false, default_value: []
    argument :use_cases, [String], required: false, default_value: []

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, sdgs:, use_cases:)
      workflows = Workflow.order(:name)
      unless search.blank?
        name_filter = Workflow.name_contains(search)
        description_filter = Workflow.joins(:workflow_descriptions)
                                     .where('LOWER(workflow_descriptions.description) like LOWER(?)', "%#{search}%")
        workflows = workflows.where(id: (name_filter.ids + description_filter.ids).uniq)
      end

      sdg_use_case_ids = []
      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      unless filtered_sdgs.empty?
        sdg_numbers = SustainableDevelopmentGoal.where(id: filtered_sdgs)
                                                .select(:number)
        sdg_use_cases = UseCase.joins(:sdg_targets)
                               .where(sdg_targets: { sdg_number: sdg_numbers })
        sdg_use_case_ids.concat(sdg_use_cases.ids)
      end

      filtered_use_cases = use_cases.reject { |x| x.nil? || x.empty? }
      filtered_use_cases = sdg_use_case_ids.concat(filtered_use_cases)
      unless filtered_use_cases.empty?
        use_case_filter = Workflow.joins(:use_case_steps)
                                  .where(use_case_steps: { use_case_id: filtered_use_cases })
        workflows = workflows.where(id: use_case_filter.uniq)
      end

      { total_count: workflows.count }
    end
  end
end
