# frozen_string_literal: true

module Queries
  class StarredObjectQuery < Queries::BaseQuery
    argument :starred_object_type, String, required: true
    argument :starred_object_value, String, required: true
    argument :source_object_type, String, required: true
    argument :source_object_value, String, required: true

    type Types::StarredObjectType, null: true

    def resolve(starred_object_type:, starred_object_value:, source_object_type:, source_object_value:)
      StarredObject.find_by(
        source_object_type:,
        source_object_value:,
        starred_object_type:,
        starred_object_value:
      )
    end
  end

  class StarredObjectsQuery < Queries::BaseQuery
    argument :source_object_type, String, required: true
    argument :source_object_value, String, required: true

    type [Types::StarredObjectType], null: false

    def resolve(source_object_type:, source_object_value:)
      StarredObject.where(source_object_type:, source_object_value:)
    end
  end
end
