# frozen_string_literal: true

module Paginated
  class PaginatedMessages < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :message_type, String, required: true
    argument :offset_attributes, Attributes::OffsetAttributes, required: true

    type [Types::MessageType], null: false

    def resolve(search:, message_type:, offset_attributes:)
      return [] unless context[:current_user].nil?

      messages = Message.order(created_at: :desc)
      unless search.blank?
        messages = messages.where('LOWER(name) like LOWER(?)', "%#{search}%")
        messages = messages.where('LOWER(message_template) like LOWER(?)', "%#{search}%")
      end

      unless message_type.blank?
        messages = messages.where(message_type:)
      end

      offset_params = offset_attributes.to_h
      messages.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
