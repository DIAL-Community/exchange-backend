# frozen_string_literal: true

class AddColumnChatbotResponseToConversationType < ActiveRecord::Migration[7.0]
  def change
    add_column(:chatbot_conversations, :chatbot_response, :jsonb, default: {})
  end
end
