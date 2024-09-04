# frozen_string_literal: true
# app/graphql/types/extra_attribute_input_type.rb
module Types
  class ExtraAttributeInputType < GraphQL::Schema::InputObject
    graphql_name 'ExtraAttributeInput'
    description 'An extra attribute for a product'

    argument :name, String, required: true
    argument :value, GraphQL::Types::JSON, required: true
    argument :type, String, required: false
  end
end
