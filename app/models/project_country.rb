# frozen_string_literal: true

class ProjectCountry < ApplicationRecord
  belongs_to :project
  belongs_to :country
end
