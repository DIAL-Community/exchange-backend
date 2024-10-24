# frozen_string_literal: true

module Paginated
  class PaginationAttributeSector < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      # Validate access to the current entity type.
      validate_access_to_resource(Sector.new)

      sectors = Sector.order(:name)
                      .where(locale: I18n.locale)
      unless search.blank?
        sectors = sectors.name_contains(search)
      end

      { total_count: sectors.count }
    end
  end
end
