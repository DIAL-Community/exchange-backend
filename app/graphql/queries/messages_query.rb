# frozen_string_literal: true

module Queries
  class MessagesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::MessageType], null: false

    def resolve(search:)
      return [] if context[:current_user].nil?

      messages = Message.order(:name)
      messages = messages.name_contains(search) unless search.blank?
      messages
    end
  end

  class MessageQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::MessageType, null: true

    def resolve(slug:)
      return nil if context[:current_user].nil?

      Message.find_by(slug:)
    end
  end
end
