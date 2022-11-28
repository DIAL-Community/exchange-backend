# frozen_string_literal: true

class ProjectDescription < ApplicationRecord
  include Auditable

  belongs_to :project
end
