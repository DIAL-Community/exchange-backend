# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateMessage < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true

    argument :message_type, String, required: true
    argument :message_template, String, required: true
    argument :message_datetime, GraphQL::Types::ISO8601DateTime, required: true

    argument :visible, Boolean, required: true, default_value: true

    argument :location, String, required: false, default_value: nil
    argument :location_type, String, required: false, default_value: nil

    field :message, Types::MessageType, null: true
    field :errors, [String], null: true

    def resolve(name:, message_template:, message_type:, message_datetime:, visible:, location:, location_type:)
      message = Message.find_by(slug: reslug_em(name))
      message_policy = Pundit.policy(context[:current_user], message || Message.new)

      if message.nil? && !message_policy.create_allowed?
        return {
          message: nil,
          errors: ['Creating / editing message is not allowed.']
        }
      end

      if !message.nil? && !message_policy.edit_allowed?
        return {
          user: nil,
          errors: ['Creating / editing message is not allowed.']
        }
      end

      message = Message.find_by(slug: reslug_em(name))
      if message.nil?
        message = Message.new(name:, slug: reslug_em(name))

        if Message.where(slug: reslug_em(name)).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Message.slug_simple_starts_with(dataset.slug)
                                   .order(slug: :desc)
                                   .first
          message.slug += generate_offset(first_duplicate) unless first_duplicate.nil?
        end
      end

      message.message_type = message_type
      message.message_template = message_template

      message.message_datetime = message_datetime

      message.visible = visible

      message.location = location
      message.location_type = location_type

      message.created_by = context[:current_user]

      successful_operation = false
      ActiveRecord::Base.transaction do
        message.save!

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          message:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          message: nil,
          errors: dataset.errors.full_messages
        }
      end
    end
  end
end
