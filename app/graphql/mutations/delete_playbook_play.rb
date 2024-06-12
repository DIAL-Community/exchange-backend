# frozen_string_literal: true

module Mutations
  class DeletePlaybookPlay < Mutations::BaseMutation
    argument :playbook_slug, String, required: true
    argument :play_slug, String, required: true
    argument :owner, String, required: true

    field :playbook, Types::PlaybookType, null: true
    field :errors, [String], null: true

    def resolve(playbook_slug:, play_slug:, owner:)
      unless an_admin || a_content_editor || an_adli_admin
        return {
          playbook: nil,
          errors: ['Must be an admin or an editor to remove play from a playbook.']
        }
      end

      play = Play.find_by(slug: play_slug, owned_by: owner)
      playbook = Playbook.find_by(slug: playbook_slug, owned_by: owner)

      if an_adli_admin && (playbook.owned_by != DPI_TENANT_NAME || play.owned_by != DPI_TENANT_NAME)
        return {
          playbook: nil,
          errors: ['Must be admin or content editor to edit non curriculum information.']
        }
      end

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
