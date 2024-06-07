# frozen_string_literal: true

module Mutations
  class UpdatePlaybookPlays < Mutations::BaseMutation
    argument :play_slugs, [String], required: true
    argument :slug, String, required: true
    argument :owner, String, required: true

    field :playbook, Types::PlaybookType, null: true
    field :errors, [String], null: true

    def resolve(play_slugs:, slug:, owner:)
      playbook = Playbook.find_by(slug:, owned_by: owner)

      unless an_admin || a_content_editor || an_adli_admin
        return {
          playbook: nil,
          errors: ['Must be admin or content editor to update plays of a playbook.']
        }
      end

      if an_adli_admin && playbook.owned_by != DPI_TENANT_NAME
        return {
          playbook: nil,
          errors: ['Must be admin or content editor to edit non curriculum information.']
        }
      end

      index = 0
      playbook.plays = []
      play_slugs.each do |play_slug|
        current_play = Play.find_by(slug: play_slug)
        next if current_play.nil?

        playbook.plays << current_play
        playbook_play = PlaybookPlay.find_by(playbook_id: playbook.id, play_id: current_play.id)
        playbook_play.play_order = index

        assign_auditable_user(playbook_play)
        playbook_play.save
        index += 1
      end

      if playbook.save
        # Successful creation, return the created object with no errors
        {
          playbook:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          playbook: nil,
          errors: playbook.errors.full_messages
        }
      end
    end
  end
end
