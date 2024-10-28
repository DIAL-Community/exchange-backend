# frozen_string_literal: true

module Queries
  class AggregatorQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::OrganizationType, null: true

    def resolve(slug:)
      organization = Organization.find_by(slug:) if valid_slug?(slug)
      validate_access_to_instance(organization || Organization.new)
      organization
    end
  end

  class AggregatorsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::OrganizationType], null: false

    def resolve(search:)
      validate_access_to_resource(Organization.new)
      organizations = Organization.order(:name)
      organizations = organizations.name_contains(search) unless search.blank?
      organizations.where(is_mni: true)
    end
  end
end
