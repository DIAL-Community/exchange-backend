# frozen_string_literal: true

class UseCaseStepsProducts < ApplicationRecord
  belongs_to :product
  belongs_to :use_case_step
end
