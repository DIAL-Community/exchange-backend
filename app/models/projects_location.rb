# frozen_string_literal: true

class ProjectsLocation < ApplicationRecord
  belongs_to :project
  belongs_to :location
end
