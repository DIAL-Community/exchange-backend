# frozen_string_literal: true

module Paginated
  class PaginatedWorkflows < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::WorkflowType], null: false

    def resolve(search:, offset_attributes:)
      workflows = Workflow.order(:name)
      unless search.blank?
        name_filter = workflows.name_contains(search)
        desc_filter = workflows.left_joins(:workflow_descriptions)
                               .where('LOWER(workflow_descriptions.description) like LOWER(?)', "%#{search}%")
        workflows = workflows.where(id: (name_filter + desc_filter).uniq)
      end

      offset_params = offset_attributes.to_h
      workflows.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
