# frozen_string_literal: true

module Mutations
  class CreateChatbotConversation < Mutations::BaseMutation
    argument :chatbot_question, String, required: true
    argument :session_identifier, String, required: true

    field :chatbot_conversation, Types::ChatbotConversationType, null: true
    field :errors, [String], null: true

    def resolve(chatbot_question:, session_identifier:)
      if context[:current_user].nil?
        return {
          chatbot_conversation: nil,
          errors: ['Must be logged in to use this feature']
        }
      end

      chatbot_conversation = ChatbotConversation.find_by(chatbot_question:)
      if chatbot_conversation.nil?
        chatbot_conversation = ChatbotConversation.new(identifier: SecureRandom.uuid, chatbot_question:)
      end

      chatbot_conversation.session_identifier = session_identifier
      if chatbot_conversation.session_identifier.blank?
        chatbot_conversation.session_identifier = SecureRandom.uuid
      end

      connection = Faraday.new(url: 'http://chatbot-service-url/query')
      response = connection.post do |request|
        request.headers['Accept'] = 'application/json'
        request.headers['Content-Type'] = 'application/json'
        request.body = %{{
          "question": "#{chatbot_question}"
        }}
      end

      puts "Response status: #{response.status}."

      if response.status == 200
        response_as_json = JSON.parse(response.body)
        chatbot_conversation.chatbot_answer = response_as_json['response']
      end

      chatbot_conversation.user = context[:current_user]

      if chatbot_conversation.save
        # Successful creation, return the created object with no errors
        {
          chatbot_conversation:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          chatbot_conversation: nil,
          errors: chatbot_conversation.errors.full_messages
        }
      end
    end
  end
end
