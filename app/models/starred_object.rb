# frozen_string_literal: true

class StarredObject < ApplicationRecord
  attribute :object_type_name, :string
  enum object_type_name: {
    ORGANIZATION: 'ORGANIZATION',
    PROJECT: 'PROJECT'
  }
end
