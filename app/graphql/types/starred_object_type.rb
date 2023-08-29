# frozen_string_literal: true

module Types
  class StarredObjectType < Types::BaseObject
    field :id, ID, null: false

    field :starred_object_type, String, null: false
    field :starred_object_value, String, null: false
    field :source_object_type, String, null: false
    field :source_object_value, String, null: false

    field :starred_date, GraphQL::Types::ISO8601Date, null: false
    field :starred_by_email, String, null: false

    def starred_by_email
      starred_by_user = User.find_by(id: object.starred_by_id)
      starred_by_user&.email
    end
  end
end
