# frozen_string_literal: true

module Paginated
  class PaginatedExtraAttributeDefinitions < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::ExtraAttributeDefinitionType], null: false

    def resolve(search:, offset_attributes:)
      # Validate access to the current entity type.
      validate_access_to_resource(ExtraAttributeDefinition.new)

      extra_attribute_definitions = ExtraAttributeDefinition.order(:name)
      unless search.blank?
        extra_attribute_definitions = extra_attribute_definitions.name_contains(search)
      end

      offset_params = offset_attributes.to_h
      extra_attribute_definitions.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
