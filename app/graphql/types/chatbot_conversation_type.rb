# frozen_string_literal: true

module Types
  class ChatbotConversationType < Types::BaseObject
    field :id, ID, null: false

    field :identifier, String, null: false
    field :session_identifier, String, null: false

    field :chatbot_question, String, null: false
    field :chatbot_answer, String, null: false

    field :chatbot_references, [String], null: true do
      argument :first, Integer, required: false
    end

    def chatbot_references(reference_context)
      chatbot_response = object.chatbot_response
      chatbot_references = []

      counter = 0
      chatbot_response['output']['context'].each do |context|
        break if counter >= reference_context[:first]
        context_metadata = context['metadata']
        chatbot_references << context_metadata['source'] unless context_metadata['source'].nil?
        counter += 1
      end
      chatbot_references
    end
  end
end
