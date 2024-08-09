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

  class ChatbotConversationStartersQuery < Queries::BaseQuery
    type GraphQL::Types::JSON, null: false

    def resolve
      default_question_answers = YAML.load_file('data/default-chatbot-qa.yml')
      default_starter_questions = []
      default_question_answers['questions'].each do |default_question_answer|
        default_starter_questions << default_question_answer['question']
      end
      default_starter_questions
    end
  end
end
