# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreatePlay < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :owner, String, required: true
    argument :tags, [String], required: false, default_value: []
    argument :description, String, required: true
    argument :product_slugs, [String], required: false
    argument :building_block_slugs, [String], required: false
    argument :playbook_slug, String, required: false, default_value: nil
    argument :draft, Boolean, required: true, default_value: true

    field :play, Types::PlayType, null: true
    field :errors, [String], null: false

    def resolve(
      name:, slug:, owner:, description:, tags:, product_slugs:, building_block_slugs:,
      playbook_slug:, draft:
    )
      unless an_admin || a_content_editor || an_adli_admin
        return {
          play: nil,
          errors: ['Not allowed to create a play.']
        }
      end

      play = Play.find_by(slug:, owned_by: owner)
      if play.nil?
        play = Play.new(name:, owned_by: owner)
        play.slug = reslug_em(name)

        if Play.where(slug: play.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Play.slug_simple_starts_with(play.slug)
                                .order(slug: :desc)
                                .first
          play.slug = play.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
        end
      end

      if an_adli_admin && play.owned_by != DPI_TENANT_NAME
        return {
          play: nil,
          errors: ['Must be admin or content editor to edit non module information.']
        }
      end

      # Re-slug if the name is updated (not the same with the one in the db).
      if play.name != name
        play.name = name
        play.slug = reslug_em(name)

        if Play.where(slug: play.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Play.slug_simple_starts_with(play.slug)
                                .order(slug: :desc)
                                .first
          play.slug = play.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
        end
      end

      play.tags = tags
      play.owned_by = owner

      play.draft = draft

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
        play.save!

        play_description = PlayDescription.find_by(play:, locale: I18n.locale)
        play_description = PlayDescription.new if play_description.nil?
        play_description.play = play
        play_description.locale = I18n.locale
        play_description.description = description

        assign_auditable_user(play_description)
        play_description.save!

        playbook = Playbook.find_by(slug: playbook_slug)
        # Only create assignment if the playbook is not yet assigned.
        if !playbook.nil? && !play.nil?
          max_order = PlaybookPlay.where(playbook:).maximum('play_order')
          max_order = max_order.nil? ? 0 : (max_order + 1)

          assigned_play = PlaybookPlay.find_by(playbook_id: playbook.id, play_id: play.id)
          assigned_play = PlaybookPlay.new(play_order: max_order) if assigned_play.nil?
          assigned_play.play = play
          assigned_play.playbook = playbook

          assign_auditable_user(assigned_play)
          assigned_play.save!
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
      first_duplicate = Play.slug_simple_starts_with(base_play.slug)
                            .order(slug: :desc)
                            .first
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
