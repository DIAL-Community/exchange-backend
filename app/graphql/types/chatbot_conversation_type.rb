# frozen_string_literal: true

module Types
  class ChatbotConversationType < Types::BaseObject
    field :id, ID, null: false

    field :identifier, String, null: false
    field :session_identifier, String, null: false

    field :chatbot_question, String, null: false
    field :chatbot_answer, String, null: false
  end
end
