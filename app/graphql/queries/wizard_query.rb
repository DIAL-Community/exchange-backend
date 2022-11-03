# frozen_string_literal: true

module Queries
  class WizardQuery < Queries::BaseQuery
    argument :sector, String, required: false
    argument :use_case, String, required: false
    argument :sdg, String, required: false
    argument :building_blocks, [String], required: false

    type Types::WizardType, null: false

    def resolve(sector:, use_case:, sdg:, building_blocks:)
      wizard = {}
      wizard['digital_principles'] = DigitalPrinciple.all

      curr_sector = Sector.find_by(name: sector, locale: I18n.locale)
      curr_sdg = SustainableDevelopmentGoal.find_by(name: sdg)

      if use_case == ''
        sector_use_cases = []
        sdg_use_cases = []

        unless curr_sector.nil?
          sector_use_cases = UseCase.where(sector_id: curr_sector.id, maturity: 'PUBLISHED')
        end

        unless curr_sdg.nil?
          curr_targets = SdgTarget.where(sdg_number: curr_sdg.number)
          sdg_use_cases = UseCase.where(
            "id in (select use_case_id from use_cases_sdg_targets where sdg_target_id in (?)) and maturity='PUBLISHED'",
            curr_targets.ids
          )
        end
        wizard['use_cases'] = (sector_use_cases + sdg_use_cases).uniq
      else
        wizard['use_cases'] = [UseCase.find_by(name: use_case)]
      end

      wizard['building_blocks'] = BuildingBlock.where(name: building_blocks)
      # Build list of resources manually
      wizard['resources'] = Resource.all
      wizard
    end
  end
end
