# frozen_string_literal: true

module Paginated
  class PaginatedSiteSettings < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::SiteSettingType], null: false

    def resolve(search:, offset_attributes:)
      if !unsecured_read_allowed && context[:current_user].nil?
        return []
      end

      return [] unless an_admin

      site_settings = SiteSetting.order(:name)
      unless search.blank?
        site_settings = site_settings.name_contains(search)
      end

      offset_params = offset_attributes.to_h
      site_settings.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
