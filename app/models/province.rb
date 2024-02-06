# frozen_string_literal: true

class Province < ApplicationRecord
  belongs_to :country
  has_many :cities, dependent: :destroy

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
