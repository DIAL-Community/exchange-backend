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
        # Don't try to save if the description is the same.
        return {
          play:,
          errors: []
        }
      end

      updated_description = Nokogiri::HTML.fragment(description)
      existing_description = Nokogiri::HTML.fragment(play_description.description)
      validate_equality(updated_description, existing_description)

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

    def validate_equality(updated_description, existing_description)
      if updated_description.children.count != existing_description.children.count
        # Don't try to save if the number of elements is different.
        return {
          play:,
          errors: []
        }
      end

      element_count = updated_description.children.count
      element_count.times do |index|
        current_updated_element = updated_description.children[index]
        current_existing_element = existing_description.children[index]

        if current_existing_element.to_html != current_updated_element.to_html
          if current_updated_element.name == 'span' && current_updated_element.attributes['data-lexical-poll-question']
          elsif current_updated_element.children.count > 0 || current_existing_element.children.count > 0
            validate_equality(current_updated_element, current_existing_element)
          else
            # The node is different, but the last node is not a poll element
            return {
              play:,
              errors: []
            }
          end
        end
      end
    end
  end
end
