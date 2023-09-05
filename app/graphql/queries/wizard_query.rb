# frozen_string_literal: true

module Queries
  class WizardQuery < Queries::BaseQuery
    type Types::WizardType, null: false

    def resolve
      wizard = {}
      wizard['digital_principles'] = DigitalPrinciple.all
      wizard['resources'] = Resource.where(show_in_wizard: true)
      wizard
    end
  end
end
