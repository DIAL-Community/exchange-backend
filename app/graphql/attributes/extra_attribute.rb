# frozen_string_literal: true

module Attributes
  class ExtraAttribute < Abstract::BaseInputObject
    graphql_name 'ExtraAttribute'
    description 'An extra attribute for a product'

    # Required fields for the extra attribute entry.
    argument :name, String, required: true
    argument :value, GraphQL::Types::JSON, required: true

    # Optional fields for the extra attribute entry.
    argument :type, String, required: false
    # More optional fields for the extra attribute entry.
    argument :index, Integer, required: false
    argument :title, String, required: false
    argument :description, String, required: false
  end
end
