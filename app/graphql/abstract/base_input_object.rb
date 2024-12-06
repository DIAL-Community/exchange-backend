# frozen_string_literal: true

module Abstract
  class BaseInputObject < GraphQL::Schema::InputObject
    argument_class Abstract::BaseArgument
  end
end
