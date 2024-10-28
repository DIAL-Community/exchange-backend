# frozen_string_literal: true

module Queries
  class SustainableDevelopmentGoalQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::SustainableDevelopmentGoalType, null: true

    def resolve(slug:)
      sdg = SustainableDevelopmentGoal.find_by(slug:) if valid_slug?(slug)
      validate_access_to_instance(sdg || SustainableDevelopmentGoal.new)
      sdg
    end
  end

  class SustainableDevelopmentGoalsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::SustainableDevelopmentGoalType], null: false

    def resolve(search:)
      validate_access_to_resource(SustainableDevelopmentGoal.new)
      sdgs = SustainableDevelopmentGoal.order(:number)
      unless search.blank?
        sdg_name = sdgs.name_contains(search)
        sdg_desc = sdgs.where('LOWER(long_title) like LOWER(?)', "%#{search}%")
        sdgs = sdgs.where(id: (sdg_name + sdg_desc).uniq)
      end
      sdgs
    end
  end
end
