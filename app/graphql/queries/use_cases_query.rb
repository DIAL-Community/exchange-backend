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
      UseCase.find_by(slug:)
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
      UseCaseStep.find_by(slug:)
    end
  end

  class UseCasesForSectorQuery < Queries::BaseQuery
    argument :sector_slugs, [String], required: true
    type [Types::UseCaseType], null: false

    def resolve(sector_slugs:)
      use_cases = UseCase.joins(:sector)
                         .where(sectors: { slug: sector_slugs, locale: I18n.locale })
                         .where(maturity: 'PUBLISHED')
      use_cases.uniq
    end
  end
end
