# frozen_string_literal: true

module Paginated
  class PaginatedUseCases < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sdgs, [String], required: false, default_value: []
    argument :show_beta, Boolean, required: false, default_value: false
    argument :gov_stack_only, Boolean, required: false, default_value: false
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::UseCaseType], null: false

    def resolve(search:, sdgs:, show_beta:, gov_stack_only:, offset_attributes:)
      use_cases = UseCase.order(:name)
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
      use_cases = use_cases.where.not(markdown_url: nil) if gov_stack_only

      offset_params = offset_attributes.to_h
      use_cases.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end