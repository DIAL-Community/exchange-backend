# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreatePlay < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :tags, GraphQL::Types::JSON, required: false, default_value: []
    argument :description, String, required: true
    argument :playbook_slug, String, required: false

    field :play, Types::PlayType, null: false
    field :errors, [String], null: false

    def resolve(name:, slug:, description:, tags:, playbook_slug: nil)
      unless an_admin || a_content_editor
        return {
          play: nil,
          errors: ['Not allowed to create a play.']
        }
      end

      play = Play.find_by(slug: slug)
      if play.nil?
        play = Play.new(name: name)
        play.slug = slug_em(name)

        if Play.where(slug: play.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Play.slug_simple_starts_with(play.slug).order(slug: :desc).first
          play.slug = play.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
        end
      end

      # Re-slug if the name is updated (not the same with the one in the db).
      if play.name != name
        play.name = name
        play.slug = slug_em(name)

        if Play.where(slug: play.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Play.slug_simple_starts_with(play.slug).order(slug: :desc).first
          play.slug = play.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
        end
      end

      play.tags = tags

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(play)
        play.save

        play_desc = PlayDescription.find_by(play: play, locale: I18n.locale)
        play_desc = PlayDescription.new if play_desc.nil?
        play_desc.play = play
        play_desc.locale = I18n.locale
        play_desc.description = description

        assign_auditable_user(play_desc)
        if play_desc.save
          # Need to figure out how to add logger here!
          puts("Description for '#{play.name}' saved.")
        end

        playbook = Playbook.find_by(slug: playbook_slug)
        assigned_play = PlaybookPlay
                        .joins(:playbook)
                        .joins(:play)
                        .find_by(playbook: { slug: playbook_slug }, play: { slug: play.slug })
        # Only create assignment if the playbook is not yet assigned.
        if !playbook.nil? && assigned_play.nil?
          max_order = PlaybookPlay.where(playbook: playbook).maximum('order')
          max_order = max_order.nil? ? 0 : (max_order + 1)
          assigned_play = PlaybookPlay.new
          assigned_play.play = play
          assigned_play.playbook = playbook
          assigned_play.order = max_order

          assign_auditable_user(assigned_play)
          if assigned_play.save
            # Need to figure out how to add logger here!
            puts("Play '#{play.name}' assigned to '#{playbook.name}'.")
          end
        end

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          play: play,
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

  class DuplicatePlay < Mutations::BaseMutation
    include Modules::Slugger

    argument :play_slug, String, required: true

    field :play, Types::PlayType, null: false
    field :errors, [String], null: false

    def resolve(play_slug:)
      unless an_admin
        return {
          play: nil,
          errors: ['Not allowed to duplicate a play.']
        }
      end

      base_play = Play.find_by(slug: play_slug)
      if base_play.nil?
        return {
          play: nil,
          errors: 'Unable to find play to duplicate.'
        }
      end

      # Create a duplicate of the base play object.
      duplicate_play = base_play.dup
      assign_auditable_user(duplicate_play)

      # Update the slug to the new slug value ($slug + '_dupX').
      first_duplicate = Play.slug_simple_starts_with(base_play.slug).order(slug: :desc).first
      duplicate_play.slug = duplicate_play.slug + generate_offset(first_duplicate)

      if duplicate_play.save
        {
          play: duplicate_play,
          errors: []
        }
      else
        {
          play: nil,
          errors: "Unable to create duplicate play record. Message: #{duplicate_play.errors.full_messages}."
        }
      end
    end
  end

  class UpdatePlayOrder < Mutations::BaseMutation
    argument :playbook_slug, String, required: true
    argument :play_slug, String, required: true
    argument :operation, String, required: true
    argument :distance, Integer, required: false
    argument :play_order, Integer, required: false

    field :play, Types::PlayType, null: false
    field :errors, [String], null: false

    def resolve(playbook_slug:, play_slug:, operation:, distance: 0, play_order: 0)
      unless an_admin
        return {
          play: nil,
          errors: ['Not allowed to update playbook.']
        }
      end

      playbook = Playbook.find_by(slug: playbook_slug)

      if playbook.nil?
        return {
          play: nil,
          errors: 'Unable to find playbook record.'
        }
      end

      play = Play.find_by(slug: play_slug)

      if play.nil?
        return {
          play: nil,
          errors: 'Unable to find play record.'
        }
      end

      successful_operation = false
      case operation
      when 'UNASSIGN'
        # We're deleting the play because the order -1
        playbook_play = playbook.playbook_plays[play_order]
        deleted = PlaybookPlay.delete_by(playbook: playbook, play: play, order: playbook_play.order)
        successful_operation = true if deleted == 1
      when 'ASSIGN'
        # We're adding a play, the order is length of the current plays (appending as the last play).
        max_order = PlaybookPlay.where(playbook: playbook).maximum('order')
        max_order = max_order.nil? ? 0 : (max_order + 1)

        assigned_play = PlaybookPlay.new
        assigned_play.play = play
        assigned_play.playbook = playbook
        assigned_play.order = max_order
        successful_operation = true if assigned_play.save
      else
        # Reordering actually trigger swap order with adjacent play.
        playbook_play = PlaybookPlay.find_by(playbook: playbook, play: play)
        playbook_play_index = playbook.playbook_plays.index(playbook_play)
        # Find adjacent play
        swapped_playbook_play = playbook.playbook_plays[playbook_play_index + distance]
        # Swap the order
        temp_order = playbook_play.order
        playbook_play.order = swapped_playbook_play.order
        swapped_playbook_play.order = temp_order
        # Save both playbook_play

        ActiveRecord::Base.transaction do
          playbook_play.save
          swapped_playbook_play.save
          successful_operation = true
        end
      end

      if successful_operation
        {
          play: play,
          errors: []
        }
      else
        {
          play: nil,
          errors: playbook.errors.full_messages
        }
      end
    end
  end
end
