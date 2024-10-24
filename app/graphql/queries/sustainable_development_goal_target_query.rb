# frozen_string_literal: true

module Queries
  class SustainableDevelopmentGoalTargetQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::SustainableDevelopmentGoalTargetType, null: true

    def resolve(slug:)
      sdg_target = SdgTarget.find_by(slug:) if valid_slug?(slug)
      sdg_target
    end
  end

  class SustainableDevelopmentGoalTargetsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::SustainableDevelopmentGoalTargetType], null: false

    def resolve(search:)
      sdg_targets = SdgTarget.order(:sdg_number).order(:target_number)
      sdg_targets = sdg_targets.name_contains(search) unless search.blank?
      sdg_targets
    end
  end
end
