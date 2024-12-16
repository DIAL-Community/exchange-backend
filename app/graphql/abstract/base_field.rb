# frozen_string_literal: true

module Abstract
  class BaseField < GraphQL::Schema::Field
    argument_class Abstract::BaseArgument
  end
end
