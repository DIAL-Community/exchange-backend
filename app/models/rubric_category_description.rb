# frozen_string_literal: true

class RubricCategoryDescription < ApplicationRecord
  include Auditable

  belongs_to :rubric_category
end
