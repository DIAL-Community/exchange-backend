# frozen_string_literal: true

class SiteSetting < ApplicationRecord
  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
end
