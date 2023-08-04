# frozen_string_literal: true

module Paginated
  class PaginationAttributeWorkflow < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      workflows = Workflow.order(:name)
      unless search.blank?
        name_filter = workflows.name_contains(search)
        desc_filter = workflows.left_joins(:workflow_descriptions)
                               .where('LOWER(workflow_descriptions.description) like LOWER(?)', "%#{search}%")
        workflows = workflows.where(id: (name_filter + desc_filter).uniq)
      end

      { total_count: workflows.count }
    end
  end
end
