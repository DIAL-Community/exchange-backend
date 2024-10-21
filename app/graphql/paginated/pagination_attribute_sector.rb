# frozen_string_literal: true

module Paginated
  class PaginationAttributeSector < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      if !unsecured_read_allowed && context[:current_user].nil?
        return { total_count: 0 }
      end

      sectors = Sector.order(:name)
                      .where(locale: I18n.locale)
      unless search.blank?
        sectors = sectors.name_contains(search)
      end

      { total_count: sectors.count }
    end
  end
end
