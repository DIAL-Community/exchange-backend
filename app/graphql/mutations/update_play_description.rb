# frozen_string_literal: true

module Mutations
  class UpdatePlayDescription < Mutations::BaseMutation
    argument :slug, String, required: true
    argument :owner, String, required: true
    argument :description, String, required: true

    field :play, Types::PlayType, null: true
    field :errors, [String], null: true

    def resolve(slug:, owner:, description:)
      if context[:current_user].nil?
        return {
          play: nil,
          errors: ['Not allowed to update a play.']
        }
      end

      play = Play.find_by(slug:, owned_by: owner)
      if play.nil?
        return {
          play: nil,
          errors: ['Unable to find play.']
        }
      end

      play_description = PlayDescription.find_by(play:, locale: I18n.locale)
      if play_description.description == description
        return {
          play:,
          errors: []
        }
      end

      play_description.description = description

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(play_description)
        play_description.save!
        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          play:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          play: nil,
          errors: play.errors.full_messages
        }
      end
    end
  end
end
