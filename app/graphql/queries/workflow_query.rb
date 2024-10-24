# frozen_string_literal: true

module Queries
  class WorkflowQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::WorkflowType, null: true

    def resolve(slug:)
      workflow = Workflow.find_by(slug:) if valid_slug?(slug)
      validate_access_to_resource(workflow || Workflow.new)
      workflow
    end
  end

  class WorkflowsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::WorkflowType], null: false

    def resolve(search:)
      validate_access_to_resource(Workflow.new)
      workflows = Workflow.order(:name)
      workflows = workflows.name_contains(search) unless search.blank?
      workflows
    end
  end
end
