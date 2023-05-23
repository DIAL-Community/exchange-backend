# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreatePlay < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :tags, GraphQL::Types::JSON, required: false, default_value: []
    argument :moves, GraphQL::Types::JSON, required: false, default_value: []
    argument :description, String, required: true
    argument :product_slugs, [String], required: false
    argument :building_block_slugs, [String], required: false
    argument :playbook_slug, String, required: false, default_value: nil

    field :play, Types::PlayType, null: true
    field :errors, [String], null: false

    def resolve(name:, slug:, description:, tags:, product_slugs:, building_block_slugs:, playbook_slug:, moves:)
      unless an_admin || a_content_editor
        return {
          play: nil,
          errors: ['Not allowed to create a play.']
        }
      end

      play = Play.find_by(slug:)
      if play.nil?
        play = Play.new(name:)
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

      play.building_blocks = []
      building_block_slugs&.each do |building_block_slug|
        current_building_block = BuildingBlock.find_by(slug: building_block_slug)
        play.building_blocks << current_building_block unless current_building_block.nil?
      end

      play.products = []
      product_slugs&.each do |product_slug|
        current_product = Product.find_by(slug: product_slug)
        play.products << current_product unless current_product.nil?
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(play)
        play.save

        play_desc = PlayDescription.find_by(play:, locale: I18n.locale)
        play_desc = PlayDescription.new if play_desc.nil?
        play_desc.play = play
        play_desc.locale = I18n.locale
        play_desc.description = description

        assign_auditable_user(play_desc)
        play_desc.save

        index = 0
        moves.each do |move|
          play_move = PlayMove.find_by(play_id: play.id, id: move['id'])
          next if play_move.nil?

          play_move.move_order = index
          assign_auditable_user(play_move)
          play_move.save

          index += 1
        end

        playbook = Playbook.find_by(slug: playbook_slug)
        assigned_play = PlaybookPlay
                        .joins(:playbook)
                        .joins(:play)
                        .find_by(playbook: { slug: playbook_slug }, play: { slug: play.slug })
        # Only create assignment if the playbook is not yet assigned.
        if !playbook.nil? && assigned_play.nil?
          max_order = PlaybookPlay.where(playbook:).maximum('play_order')
          max_order = max_order.nil? ? 0 : (max_order + 1)
          assigned_play = PlaybookPlay.new
          assigned_play.play = play
          assigned_play.playbook = playbook
          assigned_play.play_order = max_order

          assign_auditable_user(assigned_play)
          assigned_play.save
        end

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

  class DuplicatePlay < Mutations::BaseMutation
    include Modules::Slugger

    argument :play_slug, String, required: true

    field :play, Types::PlayType, null: true
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
end
