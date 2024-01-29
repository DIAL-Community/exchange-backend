# frozen_string_literal: true

class CategoryIndicatorDescription < ApplicationRecord
  belongs_to :category_indicator

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
