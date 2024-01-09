# frozen_string_literal: true

module Paginated
  class PaginatedUseCases < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sdgs, [String], required: false, default_value: []
    argument :show_beta, Boolean, required: false, default_value: false
    argument :show_gov_stack_only, Boolean, required: false, default_value: false
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::UseCaseType], null: false

    def resolve(search:, sdgs:, show_beta:, show_gov_stack_only:, offset_attributes:)
      if !unsecure_read_allowed && context[:current_user].nil?
        return []
      end

      use_cases = UseCase.order(:name).distinct
      unless search.blank?
        name_filter = use_cases.name_contains(search)
        desc_filter = use_cases.left_joins(:use_case_descriptions)
                               .where('LOWER(use_case_descriptions.description) like LOWER(?)', "%#{search}%")
        use_cases = use_cases.where(id: (name_filter + desc_filter).uniq)
      end

      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      unless filtered_sdgs.empty?
        sdg_numbers = SustainableDevelopmentGoal.where(id: filtered_sdgs)
                                                .select(:number)
        use_cases = use_cases.left_joins(:sdg_targets)
                             .where(sdg_targets: { sdg_number: sdg_numbers })
      end

      use_cases = use_cases.where(maturity: UseCase.entity_status_types[:PUBLISHED]) unless show_beta

      use_cases = use_cases.where.not(markdown_url: nil) if show_gov_stack_only
      use_cases = use_cases.where(gov_stack_entity: show_gov_stack_only) if show_gov_stack_only

      offset_params = offset_attributes.to_h
      use_cases.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end

  class PaginatedWizardUseCases < Queries::BaseQuery
    argument :sectors, [String], required: false, default_value: []
    argument :use_cases, [String], required: false, default_value: []
    argument :sdgs, [String], required: false, default_value: []
    argument :building_blocks, [String], required: false, default_value: []
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::UseCaseType], null: false

    def resolve(sectors:, use_cases:, sdgs:, offset_attributes:)
      curr_sectors = Sector.where(id: sectors)
      curr_sdgs = SustainableDevelopmentGoal.where(id: sdgs)

      if use_cases.empty?
        output_use_cases = UseCase.none
        sdg_use_cases = nil
        unless curr_sectors.nil?
          sector_use_cases = UseCase.where(sector_id: curr_sectors, maturity: 'PUBLISHED')
        end

        curr_sdgs.each do |curr_sdg|
          next if curr_sdgs.nil?
          curr_targets = SdgTarget.where(sdg_number: curr_sdg.number)
          sdg_use_cases = UseCase.where(
            "id in (select use_case_id from use_cases_sdg_targets where sdg_target_id in (?)) and maturity='PUBLISHED'",
            curr_targets.ids
          )
        end

        output_use_cases = output_use_cases.or(sdg_use_cases) unless sdg_use_cases.nil?
        output_use_cases = output_use_cases.or(sector_use_cases) unless sector_use_cases.nil?
      else
        output_use_cases = UseCase.where(id: use_cases)
      end

      offset_params = offset_attributes.to_h
      output_use_cases.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
