# frozen_string_literal: true

module Queries
  class AdliConfigurationQuery < Queries::BaseQuery
    type GraphQL::Types::JSON, null: false

    def resolve
      YAML.load_file('data/yaml/adli-configuration.yml')
    end
  end
end
