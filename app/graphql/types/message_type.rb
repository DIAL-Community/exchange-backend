# frozen_string_literal: true

module Types
  class SimpleUserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :username, String, null: false
  end

  class MessageType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false

    field :message_type, String, null: false
    field :message_template, String, null: false
    field :message_datetime, GraphQL::Types::ISO8601Date, null: false

    field :parsed_message, String, null: false
    def parsed_message
      current_user = context[:current_user]
      object.message_template
            .gsub('%{current_date}%', object.created_at.strftime('%m/%d/%Y'))
            .gsub('%{current_time}%', object.created_at.strftime('%H:%M:%S %:z'))
            .gsub('%{current_datetime}%', object.created_at.strftime('%m/%d/%Y %H:%M:%S %:z'))
            .gsub('%{user_email}%', current_user.email)
            .gsub('%{user_username}%', current_user.username)
    end

    field :visible, Boolean, null: false

    field :location, String, null: true
    field :location_type, String, null: true

    field :created_at, GraphQL::Types::ISO8601Date, null: false
    field :created_by, SimpleUserType, null: false
    def created_by
      object.created_by
    end
  end
end
