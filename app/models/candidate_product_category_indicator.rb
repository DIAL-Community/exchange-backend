# frozen_string_literal: true

class CandidateProductCategoryIndicator < ApplicationRecord
  belongs_to :candidate_product
  belongs_to :category_indicator

  def category_indicator
    CategoryIndicator.find_by(id: category_indicator_id)
  end
end
