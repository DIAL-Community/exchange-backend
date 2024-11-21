# frozen_string_literal: true

module Paginated
  class PaginationAttributeSiteSetting < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      # Validate access to the current entity type.
      validate_access_to_resource(SiteSetting.new)

      site_settings = SiteSetting.order(:name)
      unless search.blank?
        site_settings = site_settings.name_contains(search)
      end

      { total_count: site_settings.count }
    end
  end
end
