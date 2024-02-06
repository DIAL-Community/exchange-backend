# frozen_string_literal: true

class ProjectOrganization < ApplicationRecord
  belongs_to :project
  belongs_to :organization
end
