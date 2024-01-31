# frozen_string_literal: true

class Classification < ApplicationRecord
  has_many :product_classifications

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
