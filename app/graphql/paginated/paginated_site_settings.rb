# frozen_string_literal: true

module Paginated
  class PaginatedSiteSettings < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::SiteSettingType], null: false

    def resolve(search:, offset_attributes:)
      # Validate access to the current entity type.
      validate_access_to_resource(SiteSetting.new)

      site_settings = SiteSetting.order(:name)
      unless search.blank?
        site_settings = site_settings.name_contains(search)
      end

      offset_params = offset_attributes.to_h
      site_settings.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
