# frozen_string_literal: true

module Paginated
  class PaginatedWorkflows < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sdgs, [String], required: false, default_value: []
    argument :use_cases, [String], required: false, default_value: []
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::WorkflowType], null: false

    def resolve(search:, sdgs:, use_cases:, offset_attributes:)
      # Validate access to the current entity type.
      validate_access_to_resource(Workflow.new)

      workflows = Workflow.order(:name)
      unless search.blank?
        name_filter = Workflow.name_contains(search).distinct
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
        sdg_use_case_ids += sdg_use_cases.ids unless sdg_use_cases.empty?
      end

      filtered_use_cases = use_cases.reject { |x| x.nil? || x.empty? }
      filtered_use_cases = sdg_use_case_ids + filtered_use_cases
      unless filtered_use_cases.empty?
        use_case_filter = Workflow.joins(:use_case_steps)
                                  .where(use_case_steps: { use_case_id: filtered_use_cases })
        workflows = workflows.where(id: use_case_filter.uniq)
      end

      offset_params = offset_attributes.to_h
      workflows.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
