# frozen_string_literal: true

class Resource < ApplicationRecord
  include Auditable

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
end
