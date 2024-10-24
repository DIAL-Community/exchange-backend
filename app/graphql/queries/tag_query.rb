# frozen_string_literal: true

module Queries
  class TagQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::TagType, null: true

    def resolve(slug:)
      tag = Tag.find_by(slug:) if valid_slug?(slug)
      validate_access_to_resource(tag || Tag.new)
      tag
    end
  end

  class TagsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::TagType], null: false

    def resolve(search:)
      validate_access_to_resource(Tag.new)
      tags = Tag.order(:name)
      tags = tags.name_contains(search) unless search.blank?
      tags
    end
  end
end
