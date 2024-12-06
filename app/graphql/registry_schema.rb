# frozen_string_literal: true

class RegistrySchema < GraphQL::Schema
  max_depth(13)

  mutation(Registry::MutationType)
  query(Registry::QueryType)
end
