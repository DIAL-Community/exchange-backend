# frozen_string_literal: true

module Queries
  class SustainableDevelopmentGoalsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::SustainableDevelopmentGoalType], null: false

    def resolve(search:)
      sdgs = SustainableDevelopmentGoal.order(:number)
      unless search.blank?
        sdg_name = sdgs.name_contains(search)
        sdg_desc = sdgs.where('LOWER(long_title) like LOWER(?)', "%#{search}%")
        sdgs = sdgs.where(id: (sdg_name + sdg_desc).uniq)
      end
      sdgs
    end
  end

  class SustainableDevelopmentGoalQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::SustainableDevelopmentGoalType, null: true

    def resolve(slug:)
      SustainableDevelopmentGoal.find_by(slug:)
    end
  end
end
