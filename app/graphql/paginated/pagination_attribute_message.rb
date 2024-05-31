# frozen_string_literal: true

module Paginated
  class PaginationAttributeMessage < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :message_type, String, required: true

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, message_type:)
      return { total_count: 0 } unless context[:current_user].nil?

      unless search.blank?
        messages = messages.where('LOWER(name) like LOWER(?)', "%#{search}%")
        messages = messages.where('LOWER(message_template) like LOWER(?)', "%#{search}%")
      end

      unless message_type.blank?
        messages = messages.where(message_type:)
      end

      { total_count: messages.count }
    end
  end
end
