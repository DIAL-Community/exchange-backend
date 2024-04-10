# frozen_string_literal: true

class CreateChatbotConversations < ActiveRecord::Migration[7.0]
  def change
    create_table(:chatbot_conversations) do |t|
      t.string(:identifier, null: false)
      t.string(:session_identifier, null: false)

      t.string(:chatbot_question, null: false)
      t.string(:chatbot_answer, null: false)
      t.references(:user, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
