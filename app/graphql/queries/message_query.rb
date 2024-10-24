# frozen_string_literal: true

module Queries
  class MessageQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::MessageType, null: true

    def resolve(slug:)
      message = Message.find_by(slug:) if valid_slug?(slug)
      validate_access_to_resource(message || Message.new)
      message
    end
  end

  class MessagesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::MessageType], null: false

    def resolve(search:)
      validate_access_to_resource(Message.new)
      messages = Message.order(:name)
      messages = messages.name_contains(search) unless search.blank?
      messages
    end
  end
end
