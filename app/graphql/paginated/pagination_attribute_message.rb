# frozen_string_literal: true

module Paginated
  class PaginationAttributeMessage < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :message_type, String, required: false, default_value: ''
    argument :visible_only, Boolean, required: false, default_value: false

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, message_type:, visible_only:)
      return { total_count: 0 } if context[:current_user].nil?

      messages = Message.all
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

      { total_count: messages.count }
    end
  end
end
