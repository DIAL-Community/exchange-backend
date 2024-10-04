# frozen_string_literal: true

class CandidateStatus < ApplicationRecord
  scope :name_contains, ->(name) { where('LOWER(datasets.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(datasets.slug) like LOWER(?)', "#{slug}%\\_") }

  has_many :next_candidate_statuses, class_name: 'CandidateStatus', foreign_key: 'previous_candidate_status_id'
  belongs_to :previous_candidate_status, class_name: 'CandidateStatus', optional: true

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
