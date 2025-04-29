# frozen_string_literal: true

module Paginated
  class PaginationAttributeExtraAttributeDefinition < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      # Validate access to the current entity type.
      validate_access_to_resource(ExtraAttributeDefinition.new)

      extra_attribute_definitions = ExtraAttributeDefinition.order(:name)
      unless search.blank?
        extra_attribute_definitions = extra_attribute_definitions.name_contains(search)
      end

      { total_count: extra_attribute_definitions.count }
    end
  end
end
