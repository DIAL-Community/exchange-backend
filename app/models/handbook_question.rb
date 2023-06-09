# frozen_string_literal: true

class HandbookQuestion < ApplicationRecord
  belongs_to :handbook_page
  has_many :handbook_answers, autosave: true
end
