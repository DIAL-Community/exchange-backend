# frozen_string_literal: true

class UseCaseStepDescription < ApplicationRecord
  include Auditable

  belongs_to :use_case_step
end
