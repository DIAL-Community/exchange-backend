# frozen_string_literal: true
class RegionsCountry < ApplicationRecord
  belongs_to :region
  belongs_to :country
end
