# frozen_string_literal: true

class BuildingBlockDescription < ApplicationRecord
  include Auditable
  belongs_to :building_block

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
