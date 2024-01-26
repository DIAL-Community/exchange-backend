# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreatePlaybook < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :cover, ApolloUploadServer::Upload, required: false
    argument :author, String, required: false
    argument :tags, [String], required: false, default_value: []
    argument :overview, String, required: true
    argument :audience, String, required: false, default_value: ''
    argument :outcomes, String, required: false, default_value: ''
    argument :draft, Boolean, required: true, default_value: true

    field :playbook, Types::PlaybookType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, author:, tags:, overview:, audience:, outcomes:, cover: nil, draft:)
      unless an_admin || a_content_editor
        return {
          playbook: nil,
          errors: ['Must be admin or content editor to create a playbook']
        }
      end

      playbook = Playbook.find_by(slug:)
      if playbook.nil?
        playbook = Playbook.new(name:)
        playbook.slug = reslug_em(name)

        if Playbook.where(slug: playbook.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Playbook.slug_simple_starts_with(playbook.slug)
                                    .order(slug: :desc)
                                    .first
          playbook.slug = playbook.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
        end
      end

      # Re-slug if the name is updated (not the same with the one in the db).
      if playbook.name != name
        playbook.name = name
        playbook.slug = reslug_em(name)

        if Playbook.where(slug: playbook.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Playbook.slug_simple_starts_with(playbook.slug)
                                    .order(slug: :desc)
                                    .first
          playbook.slug = playbook.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
        end
      end

      playbook.tags = tags
      playbook.author = author
      playbook.draft = draft

      successful_operation = false
      ActiveRecord::Base.transaction do
        unless cover.nil?
          uploader = LogoUploader.new(playbook, cover.original_filename, context[:current_user])
          begin
            uploader.store!(cover)
          rescue StandardError => e
            puts "Unable to save cover for: #{playbook.name}. Standard error: #{e}."
          end
          playbook.auditable_image_changed(cover.original_filename)
        end

        assign_auditable_user(playbook)
        playbook.save

        playbook_desc = PlaybookDescription.find_by(playbook:, locale: I18n.locale)
        playbook_desc = PlaybookDescription.new if playbook_desc.nil?
        playbook_desc.playbook = playbook
        playbook_desc.locale = I18n.locale
        playbook_desc.overview = overview
        playbook_desc.audience = audience
        playbook_desc.outcomes = outcomes

        assign_auditable_user(playbook_desc)
        playbook_desc.save

        successful_operation = true
      end

      if successful_operation
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
