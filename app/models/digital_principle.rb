# frozen_string_literal: true

class DigitalPrinciple < ApplicationRecord
  has_many :principle_descriptions, dependent: :destroy

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
