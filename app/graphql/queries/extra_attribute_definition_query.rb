# frozen_string_literal: true

module Queries
  class ExtraAttributeDefinitionQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::ExtraAttributeDefinitionType, null: true

    def resolve(slug:)
      definition = ExtraAttributeDefinition.find_by(slug:) if valid_slug?(slug)
      validate_access_to_instance(definition || ExtraAttributeDefinition.new)
      definition
    end
  end

  class ExtraAttributeDefinitionsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ExtraAttributeDefinitionType], null: false

    def resolve(search:)
      validate_access_to_resource(Dataset.new)
      definitions = ExtraAttributeDefinition.order(:name)
      definitions = definitions.name_contains(search) unless search.blank?
      definitions
    end
  end
end
