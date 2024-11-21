# frozen_string_literal: true

module Paginated
  class PaginatedMessages < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :message_type, String, required: false, default_value: ''
    argument :visible_only, Boolean, required: false, default_value: false
    argument :offset_attributes, Attributes::OffsetAttributes, required: true

    type [Types::MessageType], null: false

    def resolve(search:, message_type:, visible_only:, offset_attributes:)
      # Validate access to the current entity type.
      validate_access_to_resource(Message.new)

      messages = Message.order(created_at: :desc)
      unless search.blank?
        messages_by_name = Message.where('LOWER(name) like LOWER(?)', "%#{search}%")
        messages_by_template = Message.where('LOWER(message_template) like LOWER(?)', "%#{search}%")

        messages = messages.where(id: messages_by_name.or(messages_by_template))
      end

      if visible_only
        messages = messages.where(visible: true)
      end

      unless message_type.blank?
        messages = messages.where(message_type:)
      end

      offset_params = offset_attributes.to_h
      messages.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
