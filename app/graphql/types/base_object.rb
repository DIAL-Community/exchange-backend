# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    field_class Abstract::BaseField
    connection_type_class Abstract::BaseConnection

    def current_user
      context[:current_user]
    end
  end
end
