# frozen_string_literal: true

module Mutations
  class DeletePlayMove < Mutations::BaseMutation
    argument :play_slug, String, required: true
    argument :move_slug, String, required: true
    argument :owner, String, required: true

    field :play, Types::PlayType, null: true
    field :errors, [String], null: true

    def resolve(play_slug:, move_slug:, owner:)
      unless an_admin || a_content_editor || an_adli_admin
        return {
          playbook: nil,
          errors: ['Must be an admin or an editor to remove move from a play.']
        }
      end

      play = Play.find_by(slug: play_slug, owned_by: owner)
      play_move = PlayMove.find_by(play_id: play.id, slug: move_slug)
      assign_auditable_user(play_move)

      if play_move.destroy
        # Successful deletion, return the deleted playbook with no errors
        {
          play:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          play: nil,
          errors: play.errors.full_messages
        }
      end
    end
  end
end
