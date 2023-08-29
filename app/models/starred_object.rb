# frozen_string_literal: true

class StarredObject < ApplicationRecord
  enum object_type_name: {
    ORGANIZATION: 'ORGANIZATION',
    PROJECT: 'PROJECT'
  }
end
