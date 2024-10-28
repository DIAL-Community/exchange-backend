# frozen_string_literal: true

module Queries
  class CandidateStatusQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CandidateStatusType, null: true

    def resolve(slug:)
      candidate_status = CandidateStatus.find_by(slug:) if valid_slug?(slug)
      validate_access_to_instance(candidate_status || CandidateStatus.new)
      candidate_status
    end
  end

  class CandidateStatusesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CandidateStatusType], null: false

    def resolve(search:)
      validate_access_to_resource(CandidateStatus.new)
      candidate_statuses = CandidateStatus.order(:name)
      candidate_statuses = candidate_statuses.name_contains(search) unless search.blank?
      candidate_statuses
    end
  end

  class InitialCandidateStatusesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CandidateStatusType], null: false

    def resolve(search:)
      validate_access_to_resource(CandidateStatus.new)
      candidate_statuses = CandidateStatus.order(:name).where(initial_status: true)
      candidate_statuses = candidate_statuses.name_contains(search) unless search.blank?
      candidate_statuses
    end
  end
end
