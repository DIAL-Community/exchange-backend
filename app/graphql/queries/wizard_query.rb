# frozen_string_literal: true

module Queries
  class WizardQuery < Queries::BaseQuery
    argument :sectors, [String], required: false, default_value: []
    argument :use_case, String, required: false
    argument :sdgs, [String], required: false
    argument :building_blocks, [String], required: false

    type Types::WizardType, null: false

    def resolve(sectors:, use_case:, sdgs:, building_blocks:)
      wizard = {}
      wizard['digital_principles'] = DigitalPrinciple.all

      curr_sectors = Sector.where(name: sectors, locale: I18n.locale)

      curr_sdgs = SustainableDevelopmentGoal.where(name: sdgs)

      if use_case == ''
        sector_use_cases = []
        sdg_use_cases = []

        unless curr_sectors.nil?
          sector_use_cases = UseCase.where(sector_id: curr_sectors, maturity: 'PUBLISHED')
        end

        curr_sdgs.each do |curr_sdg|
          next if curr_sdgs.nil?
          curr_targets = SdgTarget.where(sdg_number: curr_sdg.number)
          sdg_use_cases << UseCase.where(
            "id in (select use_case_id from use_cases_sdg_targets where sdg_target_id in (?)) and maturity='PUBLISHED'",
            curr_targets.ids
          )
        end
        wizard['use_cases'] = (sector_use_cases + sdg_use_cases.flatten).uniq
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
