# frozen_string_literal: true

module Mutations
  class DeletePlaybookPlay < Mutations::BaseMutation
    argument :playbook_slug, String, required: true
    argument :play_slug, String, required: true

    field :playbook, Types::PlaybookType, null: true
    field :errors, [String], null: true

    def resolve(playbook_slug:, play_slug:)
      unless an_admin || a_content_editor
        return {
          playbook: nil,
          errors: ['Must be an admin or an editor to remove play from a playbook.']
        }
      end

      play = Play.find_by(slug: play_slug)
      playbook = Playbook.find_by(slug: playbook_slug)

      playbook_play = PlaybookPlay.find_by(playbook_id: playbook.id, play_id: play.id)
      assign_auditable_user(playbook_play)

      if !playbook_play.nil? && playbook_play.destroy
        # Successful deletion, return the deleted playbook with no errors
        {
          playbook:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          playbook: nil,
          errors: playbook.errors.full_messages
        }
      end
    end
  end
end
