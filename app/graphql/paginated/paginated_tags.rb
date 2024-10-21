# frozen_string_literal: true

module Paginated
  class PaginatedTags < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::TagType], null: false

    def resolve(search:, offset_attributes:)
      if !unsecured_read_allowed && context[:current_user].nil?
        return []
      end

      tags = Tag.order(:name)
      unless search.blank?
        name_filter = tags.name_contains(search)
        desc_filter = tags.left_joins(:tag_descriptions)
                          .where('LOWER(tag_descriptions.description) like LOWER(?)', "%#{search}%")
        tags = tags.where(id: (name_filter + desc_filter).uniq)
      end

      offset_params = offset_attributes.to_h
      tags.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
