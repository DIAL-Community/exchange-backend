# frozen_string_literal: true
require 'modules/slugger'

module Mutations
  class CreatePlayMove < Mutations::BaseMutation
    include Modules::Slugger

    argument :play_slug, String, required: true
    argument :move_slug, String, required: false
    argument :owner, String, required: true
    argument :name, String, required: true
    argument :description, String, required: true
    argument :resource_slugs, [String], required: false
    argument :inline_resources, GraphQL::Types::JSON, required: false, default_value: []

    field :move, Types::PlayMoveType, null: true
    field :errors, [String], null: false

    def resolve(play_slug:, move_slug:, owner:, name:, description:, resource_slugs:, inline_resources:)
      unless an_admin || a_content_editor || an_adli_admin
        return {
          move: nil,
          errors: ['Not allowed to create a move.']
        }
      end

      play = Play.find_by(slug: play_slug, owned_by: owner)
      if play.nil?
        return {
          move: nil,
          errors: ['Unable to find play.']
        }
      end

      if an_adli_admin && play.owned_by != DPI_TENANT_NAME
        return {
          move: nil,
          errors: ['Must be admin or content editor to edit non module information.']
        }
      end

      play_move = PlayMove.find_by(play:, slug: move_slug)
      if play_move.nil?
        play_move = PlayMove.new(name:)
        play_move.slug = reslug_em("#{play.name} #{name}")

        if PlayMove.where(slug: play_move.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = PlayMove.slug_simple_starts_with(play_move.slug)
                                    .order(slug: :desc)
                                    .first
          play_move.slug = play_move.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
        end
      end

      # Re-slug if the name is updated (not the same with the one in the db).
      if play_move.name != name
        play_move.name = name
        play_move.slug = reslug_em("#{play.name} #{name}")

        if PlayMove.where(slug: play_move.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = PlayMove.slug_simple_starts_with(play_move.slug)
                                    .order(slug: :desc)
                                    .first
          play_move.slug = play_move.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
        end
      end

      play_move.play = play
      play_move.move_order = play.play_moves.count if play_move.new_record?
      play_move.inline_resources = inline_resources.reject { |r| r['name'].blank? || r['url'].blank? }

      play_move.resources = []
      resource_slugs&.each do |resource_slug|
        current_resource = Resource.find_by(slug: resource_slug)
        play_move.resources << current_resource unless current_resource.nil?
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(play_move)
        play_move.save!

        play_move_desc = PlayMoveDescription.find_by(play_move_id: play_move, locale: I18n.locale)
        if play_move_desc.nil?
          play_move_desc = PlayMoveDescription.new
          play_move_desc.play_move = play_move
          play_move_desc.locale = I18n.locale
        end
        play_move_desc.description = description

        assign_auditable_user(play_move_desc)
        play_move_desc.save!

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          move: play_move,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          move: nil,
          errors: play_move.errors.full_messages
        }
      end
    end
  end

  class CreatePlayMoveResource < Mutations::BaseMutation
    require 'modules/slugger'

    include Modules::Slugger

    argument :play_slug, String, required: true
    argument :move_slug, String, required: false
    argument :url, String, required: true
    argument :name, String, required: true
    argument :description, String, required: true
    argument :index, Integer, required: true

    field :move, Types::PlayMoveType, null: true
    field :errors, [String], null: false

    def resolve(play_slug:, move_slug:, url:, name:, description:, index:)
      return { move: nil, errors: ['Not allowed to update move.'] } unless an_admin

      play = Play.find_by(slug: play_slug)
      return { move: nil, errors: ['Unable to find play.'] } if play.nil?

      play_move = PlayMove.find_by(play:, slug: move_slug)
      return { move: nil, errors: ['Unable to find move.'] } if play_move.nil?

      if index >= play_move.inline_resources.count
        # The index is higher or equal than the current count of the resource.
        # Append the new resource to the move.
        play_move.resources << ({
          i: play_move.inline_resources.count,
          name:,
          description:,
          url:
        })
      else
        # The index is less length of the resources
        play_move.inline_resources.each_with_index do |resource, i|
          next if index != i

          resource['url'] = url
          resource['name'] = name
          resource['description'] = description
        end
      end

      assign_auditable_user(play_move)
      if play_move.save
        # Successful creation, return the created object with no errors
        { move: play_move, errors: [] }
      else
        # Failed save, return the errors to the client
        { move: nil, errors: ['Unable to save updated move data.'] }
      end
    end
  end
end
