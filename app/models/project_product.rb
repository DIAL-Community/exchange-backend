# frozen_string_literal: true

class ProjectProduct < ApplicationRecord
  belongs_to :product
  belongs_to :project
end
