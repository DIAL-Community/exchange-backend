# frozen_string_literal: true

class Setting < ApplicationRecord
  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
