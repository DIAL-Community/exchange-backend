# frozen_string_literal: true

module Queries
  class AggregatorQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::OrganizationType, null: true

    def resolve(slug:)
      Organization.find_by(slug:)
    end
  end

  class AggregatorsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::OrganizationType], null: false

    def resolve(search:)
      organizations = Organization.order(:name)
      organizations = organizations.name_contains(search) unless search.blank?
      organizations.where(is_mni: true)
    end
  end
end
