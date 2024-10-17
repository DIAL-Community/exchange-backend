# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateBuildingBlock < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :description, String, required: true
    argument :maturity, String, required: true
    argument :category, String, required: false
    argument :spec_url, String, required: false, default_value: nil
    argument :image_file, ApolloUploadServer::Upload, required: false, default_value: nil

    argument :gov_stack_entity, Boolean, required: false, default_value: false

    field :building_block, Types::BuildingBlockType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, description:, maturity:, category:, spec_url:, image_file:, gov_stack_entity:)
      building_block_policy = Pundit.policy(context[:current_user], BuildingBlock.new)
      unless building_block_policy.update_allowed?
        return {
          building_block: nil,
          errors: ['Must be admin or content editor to create / update building block.']
        }
      end

      building_block = BuildingBlock.find_by(slug:)
      if building_block.nil?
        building_block = BuildingBlock.new(name:, slug: reslug_em(name))
        # Check if we need to add _duplicate to the slug.
        first_duplicate = BuildingBlock.slug_simple_starts_with(reslug_em(name))
                                       .order(slug: :desc)
                                       .first
        unless first_duplicate.nil?
          building_block.slug += generate_offset(first_duplicate)
        end
      end

      # Re-slug if the name is updated (not the same with the one in the db).
      if building_block.name != name
        building_block.name = name
        building_block.slug = reslug_em(name)

        # Check if we need to add _duplicate to the slug.
        first_duplicate = BuildingBlock.slug_simple_starts_with(reslug_em(name))
                                       .order(slug: :desc)
                                       .first
        unless first_duplicate.nil?
          building_block.slug += generate_offset(first_duplicate)
        end
      end

      # allow user to rename use case but don't re-slug it
      building_block.name = name
      building_block.maturity = maturity
      building_block.category = category
      building_block.spec_url = spec_url

      # Only admin will be allowed to set this flag
      building_block.gov_stack_entity = gov_stack_entity if an_admin

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(building_block)
        building_block.save!

        unless image_file.nil?
          uploader = LogoUploader.new(building_block, image_file.original_filename, context[:current_user])
          begin
            uploader.store!(image_file)
          rescue StandardError => e
            puts "Unable to save image for: #{building_block.name}. Standard error: #{e}."
          end
          building_block.auditable_image_changed(image_file.original_filename)
        end

        building_block_desc = BuildingBlockDescription.find_by(
          building_block_id: building_block.id,
          locale: I18n.locale
        )
        building_block_desc = BuildingBlockDescription.new if building_block_desc.nil?
        building_block_desc.description = description
        building_block_desc.building_block_id = building_block.id
        building_block_desc.locale = I18n.locale

        assign_auditable_user(building_block_desc)
        building_block_desc.save!

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          building_block:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          building_block: nil,
          errors: building_block.errors.full_messages
        }
      end
    end
  end
end
