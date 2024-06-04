# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateMessage < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true

    argument :message_type, String, required: true
    argument :message_template, String, required: true
    argument :message_datetime, GraphQL::Types::ISO8601DateTime, required: true

    argument :visible, Boolean, required: false, default_value: true

    argument :location, String, required: false
    argument :location_type, String, required: false

    field :message, Types::MessageType, null: true
    field :errors, [String], null: true

    def resolve(name:, message_template:, message_type:, message_datetime:, visible:, location: nil, location_type: nil)
      unless an_admin || an_adli_admin
        return {
          user: nil,
          errors: ['Must be an admin to create / update message data.']
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

      puts "Message datetime: #{message_datetime}."
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
