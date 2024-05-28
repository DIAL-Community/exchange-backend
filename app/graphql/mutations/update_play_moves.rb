# frozen_string_literal: true

module Mutations
  class UpdatePlayMoves < Mutations::BaseMutation
    argument :move_slugs, [String], required: true
    argument :slug, String, required: true
    argument :owner, String, required: true

    field :play, Types::PlayType, null: true
    field :errors, [String], null: true

    def resolve(move_slugs:, slug:, owner:)
      play = Play.find_by(slug:, owned_by: owner)

      unless an_admin || a_content_editor || an_adli_admin
        return {
          play: nil,
          errors: ['Must be admin or content editor to update moves of a play.']
        }
      end

      if play.nil?
        return {
          play: nil,
          errors: ['Unable to find play.']
        }
      end

      if an_adli_admin && play.owned_by != 'dpi'
        return {
          play: nil,
          errors: ['Must be admin or content editor to edit non module.']
        }
      end

      index = 0
      move_slugs.each do |move_slug|
        play_move = PlayMove.find_by(play_id: play.id, slug: move_slug)
        next if play_move.nil?

        play_move.move_order = index
        assign_auditable_user(play_move)
        play_move.save

        index += 1
      end

      if play.save
        # Successful creation, return the created object with no errors
        {
          play:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          play: nil,
          errors: playbook.errors.full_messages
        }
      end
    end
  end
end
