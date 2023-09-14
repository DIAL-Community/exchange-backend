# frozen_string_literal: true

module Queries
  class WorkflowsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::WorkflowType], null: false

    def resolve(search:)
      workflows = Workflow.order(:name)
      workflows = workflows.name_contains(search) unless search.blank?
      workflows
    end
  end

  class WorkflowQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::WorkflowType, null: true

    def resolve(slug:)
      Workflow.find_by(slug:)
    end
  end
end
