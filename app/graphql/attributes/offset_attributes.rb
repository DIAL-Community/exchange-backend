# frozen_string_literal: true

module Attributes
  class OffsetAttributes < Types::BaseInputObject
    description "Input attributes for pagination"

    argument :limit, Integer, required: false
    argument :offset, Integer, required: true
  end
end
