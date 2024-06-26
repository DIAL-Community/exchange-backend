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
    field :message_datetime, GraphQL::Types::ISO8601DateTime, null: false

    field :parsed_message, String, null: false
    def parsed_message
      current_user = context[:current_user]
      return message_template if current_user.nil?

      current_contact = Contact.find_by(email: current_user.email)

      message_body = object.message_template
      unless date_created.nil?
        message_body = message_body.gsub('%{current_date}%', date_created.strftime('%m/%d/%Y'))
                                   .gsub('%{current_time}%', date_created.strftime('%H:%M:%S %:z'))
                                   .gsub('%{current_datetime}%', date_created.strftime('%m/%d/%Y %H:%M:%S %:z'))
      end

      unless current_contact.nil?
        message_body = message_body.gsub('%{user_name}%', current_contact&.name)
      end

      unless current_user.nil?
        message_body = message_body.gsub('%{user_email}%', current_user&.email)
                                   # Replace with current user's name or fallback to username if contact is nil.
                                   .gsub('%{user_name}%', current_user&.username)
                                   .gsub('%{user_username}%', current_user&.username)
      end
      message_body
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
