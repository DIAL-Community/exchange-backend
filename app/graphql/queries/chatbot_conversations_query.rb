# frozen_string_literal: true

module Queries
  class ChatbotConversationsQuery < Queries::BaseQuery
    argument :session_identifier, String, required: true
    argument :current_identifier, String, required: false, default_value: nil

    type [Types::ChatbotConversationType], null: false

    def resolve(session_identifier:, current_identifier:)
      return [] if context[:current_user].nil?

      chatbot_conversations = ChatbotConversation.order(:created_at)
      chatbot_conversations = chatbot_conversations.where(session_identifier:)
      chatbot_conversations = chatbot_conversations.where(user: context[:current_user])

      unless current_identifier.blank?
        chatbot_conversations = chatbot_conversations.where.not(identifier: current_identifier)
      end

      chatbot_conversations
    end
  end
end
