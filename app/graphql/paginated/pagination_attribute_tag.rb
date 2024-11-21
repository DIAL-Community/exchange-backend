# frozen_string_literal: true

module Paginated
  class PaginationAttributeTag < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      # Validate access to the current entity type.
      validate_access_to_resource(Tag.new)

      tags = Tag.order(:name)
      unless search.blank?
        name_filter = tags.name_contains(search)
        desc_filter = tags.left_joins(:tag_descriptions)
                          .where('LOWER(tag_descriptions.description) like LOWER(?)', "%#{search}%")
        tags = tags.where(id: (name_filter + desc_filter).uniq)
      end

      { total_count: tags.count }
    end
  end
end
