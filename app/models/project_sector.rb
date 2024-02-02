# frozen_string_literal: true

class ProjectProduct < ApplicationRecord
  belongs_to :project
  belongs_to :sector
end
