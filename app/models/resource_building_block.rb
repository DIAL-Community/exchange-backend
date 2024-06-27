# frozen_string_literal: true

class ResourceBuildingBlock < ApplicationRecord
  include MappingStatusType

  belongs_to :resource
  belongs_to :building_block
end
