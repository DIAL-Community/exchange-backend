# frozen_string_literal: true

module Queries
  class UseCasesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :mature, Boolean, required: false, default_value: false
    type [Types::UseCaseType], null: false

    def resolve(search:, mature:)
      if mature
        use_cases = UseCase.where(maturity: 'PUBLISHED').order(:name)
      else
        use_cases = UseCase.order(:name)
      end
      use_cases = use_cases.name_contains(search) unless search.blank?
      use_cases
    end
  end

  class UseCaseQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::UseCaseType, null: true

    def resolve(slug:)
      use_case = UseCase.find_by(slug:)
      unless use_case.nil?
        workflows = []
        if use_case.use_case_steps && !use_case.use_case_steps.empty?
          use_case.use_case_steps.each do |use_case_step|
            workflows |= use_case_step.workflows
          end
        end
        use_case.workflows = workflows.sort_by { |w| w.name.downcase }

        # Append each step's building block list to the use case's building block list
        building_blocks = []
        if use_case.use_case_steps && !use_case.use_case_steps.empty?
          use_case.use_case_steps.each do |use_case_step|
            building_blocks |= use_case_step.building_blocks
          end
        end
        use_case.building_blocks = building_blocks.sort_by(&:display_order)
      end
      use_case
    end
  end

  class SearchUseCasesQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    argument :sdgs, [String], required: false, default_value: []
    argument :show_beta, Boolean, required: false, default_value: false
    type Types::UseCaseType.connection_type, null: false

    def resolve(search:, sdgs:, show_beta:)
      use_cases = UseCase.order(:name)
      unless search.blank?
        name_ucs = use_cases.name_contains(search)
        desc_ucs = use_cases.joins(:use_case_descriptions)
                            .where('LOWER(use_case_descriptions.description) like LOWER(?)', "%#{search}%")
        use_cases = use_cases.where(id: (name_ucs + desc_ucs).uniq)
      end

      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      unless filtered_sdgs.empty?
        sdg_numbers = SustainableDevelopmentGoal.where(id: filtered_sdgs)
                                                .select(:number)
        use_cases = use_cases.joins(:sdg_targets)
                             .where(sdg_targets: { sdg_number: sdg_numbers })
      end

      use_cases = use_cases.where(maturity: UseCase.entity_status_types[:PUBLISHED]) unless show_beta

      use_cases.distinct
    end
  end

  class UseCasesStepsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::UseCaseStepType], null: false

    def resolve(search:)
      use_cases_steps = UseCaseStep.order(:name)
      use_cases_steps = use_cases_steps.name_contains(search) unless search.blank?
      use_cases_steps
    end
  end

  class UseCaseStepsQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type [Types::UseCaseStepType], null: false

    def resolve(slug:)
      use_case = UseCase.find_by(slug:)
      use_case_steps = UseCaseStep.where(use_case_id: use_case.id)
                                  .order(step_number: :asc) unless use_case.nil?
      use_case_steps
    end
  end

  class UseCaseStepQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::UseCaseStepType, null: true

    def resolve(slug:)
      use_case_step = UseCaseStep.find_by(slug:)

      # Append each step's building block list to the use case's building block list
      building_blocks = []
      use_case = use_case_step.use_case
      if use_case.use_case_steps && !use_case.use_case_steps.empty?
        use_case.use_case_steps.each do |use_case_step|
          building_blocks |= use_case_step.building_blocks
        end
      end
      use_case.building_blocks = building_blocks.sort_by(&:display_order)
      use_case_step
    end
  end

  class UseCasesForSectorQuery < Queries::BaseQuery
    argument :sectors_slugs, [String], required: true
    type [Types::UseCaseType], null: false

    def resolve(sectors_slugs:)
      use_cases = UseCase.joins(:sector)
                         .where(sectors: { slug: sectors_slugs, locale: I18n.locale })
                         .where(maturity: 'PUBLISHED')
      use_cases.uniq
    end
  end
end
