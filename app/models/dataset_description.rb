# frozen_string_literal: true

class DatasetDescription < ApplicationRecord
  include Auditable
  belongs_to :dataset

  amoeba do
    enable
  end
end
