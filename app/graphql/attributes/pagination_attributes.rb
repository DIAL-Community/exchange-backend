# frozen_string_literal: true

module Attributes
  class PaginationAttributes < Types::BaseObject
    description "Output attributes for pagination"

    field :total_count, Integer, null: false
  end
end
