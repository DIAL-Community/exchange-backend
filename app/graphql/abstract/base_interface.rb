# frozen_string_literal: true

module Abstract
  module BaseInterface
    include GraphQL::Schema::Interface

    field_class Abstract::BaseField
  end
end
