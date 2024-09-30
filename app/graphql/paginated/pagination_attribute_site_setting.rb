# frozen_string_literal: true

module Paginated
  class PaginationAttributeSiteSetting < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      if !unsecure_read_allowed && context[:current_user].nil?
        return { total_count: 0 }
      end

      return { total_count: 0 } unless an_admin

      site_settings = SiteSetting.order(:name)
      unless search.blank?
        site_settings = site_settings.name_contains(search)
      end

      { total_count: site_settings.count }
    end
  end
end
