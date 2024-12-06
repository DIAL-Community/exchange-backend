# frozen_string_literal: true

module Attributes
  class ExtraAttribute < Abstract::BaseInputObject
    graphql_name 'ExtraAttribute'
    description 'An extra attribute for a product'

    argument :name, String, required: true
    argument :value, GraphQL::Types::JSON, required: true
    argument :type, String, required: false
  end
end
