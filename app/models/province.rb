# frozen_string_literal: true

class Province < ApplicationRecord
  belongs_to :country
  has_many :cities, dependent: :destroy
end
