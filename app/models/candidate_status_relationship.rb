# frozen_string_literal: true

class CandidateStatusRelationship < ApplicationRecord
  belongs_to :current_candidate_status, foreign_key: 'current_candidate_status_id', class_name: 'CandidateStatus'
  belongs_to :next_candidate_status, foreign_key: "next_candidate_status_id", class_name: 'CandidateStatus'
end
