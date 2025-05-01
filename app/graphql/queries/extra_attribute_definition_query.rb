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
    argument :root_only, Boolean, required: false, default_value: true
    type [Types::ExtraAttributeDefinitionType], null: false

    def resolve(search:, root_only:)
      validate_access_to_resource(ExtraAttributeDefinition.new)
      definitions = ExtraAttributeDefinition.order(:title)
      definitions = definitions.title_contains(search) unless search.blank?
      definitions = definitions.where(child_extra_attribute_names: []) if root_only
      definitions
    end
  end

  class ProductExtraAttributeDefinitionsQuery < Queries::BaseQuery
    type [Types::ExtraAttributeDefinitionType], null: false

    def resolve
      validate_access_to_resource(ExtraAttributeDefinition.new)
      definitions = ExtraAttributeDefinition.order(:title)

      extra_attribute_names = []
      extra_attributes_with_children = definitions.where.not(child_extra_attribute_names: [])
      extra_attributes_with_children.each do |extra_attribute|
        extra_attribute_names += extra_attribute.child_extra_attribute_names
      end

      definitions.reject { |d| extra_attribute_names.include?(d.name) }
    end
  end
end
