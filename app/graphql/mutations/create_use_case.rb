# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateUseCase < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :sector_slug, String, required: true
    argument :maturity, String, required: true
    argument :description, String, required: true
    argument :markdown_url, String, required: false, default_value: nil
    argument :image_file, ApolloUploadServer::Upload, required: false, default_value: nil

    argument :gov_stack_entity, Boolean, required: false, default_value: false

    field :use_case, Types::UseCaseType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, sector_slug:, maturity:, description:, markdown_url:, image_file:, gov_stack_entity:)
      unless an_admin || a_content_editor
        return {
          use_case: nil,
          errors: ['Must be admin or content editor to create a use case']
        }
      end

      use_case = UseCase.find_by(slug:)
      if use_case.nil?
        use_case = UseCase.new(name:)
        slug = slug_em(name)

        # Check if we need to add _dup to the slug.
        first_duplicate = UseCase.slug_simple_starts_with(slug)
                                 .order(slug: :desc)
                                 .first
        if !first_duplicate.nil?
          use_case.slug = slug + generate_offset(first_duplicate)
        else
          use_case.slug = slug
        end
      end

      # allow user to rename use case but don't re-slug it
      use_case.name = name
      use_case.maturity = maturity
      use_case.markdown_url = markdown_url

      # Only admin will be allowed to set this flag
      use_case.gov_stack_entity = gov_stack_entity if an_admin

      sector = Sector.find_by(slug: sector_slug)
      use_case.sector = sector unless sector.nil?

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(use_case)
        use_case.save

        unless image_file.nil?
          uploader = LogoUploader.new(use_case, image_file.original_filename, context[:current_user])
          begin
            uploader.store!(image_file)
          rescue StandardError => e
            puts "Unable to save image for: #{use_case.name}. Standard error: #{e}."
          end
          use_case.auditable_image_changed(image_file.original_filename)
        end

        use_case_desc = UseCaseDescription.find_by(use_case_id: use_case.id, locale: I18n.locale)
        use_case_desc = UseCaseDescription.new if use_case_desc.nil?
        use_case_desc.description = description
        use_case_desc.use_case_id = use_case.id
        use_case_desc.locale = I18n.locale

        assign_auditable_user(use_case_desc)
        use_case_desc.save

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          use_case:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          use_case: nil,
          errors: use_case.errors.full_messages
        }
      end
    end
  end
end
