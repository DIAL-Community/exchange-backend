# frozen_string_literal: true

module Abstract
  class BaseConnection < GraphQL::Types::Relay::BaseConnection
    field :total_count, Integer, null: false

    def total_count
      object.items.size
    end
  end
end
