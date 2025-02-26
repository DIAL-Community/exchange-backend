# frozen_string_literal: true

class CandidateStatus < ApplicationRecord
  scope :name_contains, ->(name) { where('LOWER(candidate_statuses.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(candidate_statuses.slug) like LOWER(?)', "#{slug}%\\_") }

  has_many :next_candidate_status_relationships,
    join_table: 'candidate_status_relationships',
    foreign_key: 'current_candidate_status_id',
    class_name: 'CandidateStatusRelationship',
    dependent: :destroy

  has_many :next_candidate_statuses,
    through: :next_candidate_status_relationships,
    source: :next_candidate_status

  has_many :previous_candidate_status_relationships,
    join_table: 'candidate_status_relationships',
    foreign_key: 'next_candidate_status_id',
    class_name: 'CandidateStatusRelationship',
    dependent: :destroy

  has_many :previous_candidate_statuses,
    through: :previous_candidate_status_relationships,
    source: :current_candidate_status

  # TODO: This should be a record in the settings table.
  scope :name_contains_private, ->() { where("candidate_statuses.name ILIKE '%private%'") }
  scope :name_contains_internal, ->() { where("candidate_statuses.name ILIKE '%internal%'") }
  scope :name_contains_approved, ->() { where("candidate_statuses.name ILIKE '%approved%'") }

  scope :name_contains_denied, ->() { where("candidate_statuses.name ILIKE '%denied%'") }
  scope :name_contains_rejected, ->() { where("candidate_statuses.name ILIKE '%rejected%'") }

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
