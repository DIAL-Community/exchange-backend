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

      chatbot_conversation.chatbot_answer = <<-chatbot_sample_answer
        GovStack offers governments with essential tools for digital services, including building block
        specifications, a sandbox for testing (upcoming), communities of practices, and more. GovStack
        also organizes forums for digital changemakers to network with each other and exchange their
        experiences on introducing eGovernment services through the CIO Digital Leaders Forum.
      chatbot_sample_answer

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
