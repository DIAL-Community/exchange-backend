# frozen_string_literal: true

module Mutations
  class UpdateDescriptionEntity < Mutations::BaseMutation
    argument :slug, String, required: true
    argument :type, String, required: true
    argument :owner, String, required: true
    argument :field_name, String, required: true
    argument :parent_slug, String, required: false
    argument :description, String, required: true

    field :errors, [String], null: true

    def resolve_description_entity(slug, type, owner, parent_slug)
      case type
      when 'PLAY'
        play = Play.find_by(slug:, owned_by: owner)
        return nil if play.nil?
        PlayDescription.find_by(play:, locale: I18n.locale)
      when 'MOVE'
        play = Play.find_by(slug: parent_slug, owned_by: owner)
        return nil if play.nil?
        play_move = PlayMove.find_by(play:, slug: slug)
        return nil if play_move.nil?
        PlayMoveDescription.find_by(play_move_id: play_move, locale: I18n.locale)
      when 'PLAYBOOK'
        playbook = Playbook.find_by(slug:, owned_by: owner)
        return nil if playbook.nil?
        PlaybookDescription.find_by(playbook:, locale: I18n.locale)
      end
    end

    def resolve(slug:, type:, owner:, description:, field_name:, parent_slug:)
      if context[:current_user].nil?
        return {
          play: nil,
          errors: ['Not allowed to update a play.']
        }
      end

      description_entity = resolve_description_entity(slug, type, owner, parent_slug)
      if description_entity.nil?
        return {
          errors: ['Unable to resolve description entity.']
        }
      end

      if description_entity[field_name] == description
        # Don't try to save if the description is the same.
        return {
          errors: []
        }
      end

      updated_description = Nokogiri::HTML.fragment(description)
      existing_description = Nokogiri::HTML.fragment(description_entity[field_name])
      validate_equality(updated_description, existing_description)

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(description_entity)
        description_entity[field_name] = description
        description_entity.save!
        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
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
