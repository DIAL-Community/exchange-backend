# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateProduct < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :aliases, GraphQL::Types::JSON, required: false
    argument :website, String, required: false
    argument :description, String, required: true
    argument :image_file, ApolloUploadServer::Upload, required: false

    argument :commercial_product, Boolean, required: false, default_value: false
    argument :pricing_url, String, required: false, default_value: nil
    argument :pricing_model, String, required: false, default_value: nil
    argument :pricing_details, String, required: false, default_value: nil
    argument :hosting_model, String, required: false, default_value: nil
    argument :gov_stack_entity, Boolean, required: false, default_value: false
    argument :product_stage, String, required: false
    argument :extra_attributes, [Types::ExtraAttributeInputType], required: false

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(
      name:, slug:, aliases: nil, website: nil, description:, image_file: nil,
      commercial_product:, pricing_url:, pricing_model:, pricing_details:, hosting_model:,
      gov_stack_entity:, product_stage:, extra_attributes: nil
    )
      product = Product.find_by(slug:)
      unless an_admin || (a_product_owner(product.id) unless product.nil?)
        return {
          product: nil,
          errors: ['Must be admin or product owner to create a product']
        }
      end

      if product.nil?
        product = Product.new(name:)
        product.slug = reslug_em(name)

        if Product.where(slug: product.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Product.slug_simple_starts_with(product.slug)
                                   .order(slug: :desc)
                                   .first
          product.slug = product.slug + generate_offset(first_duplicate)
        end
      end

      # allow user to rename product but don't re-slug it
      product.name = name
      product.aliases = aliases
      product.website = website

      product.commercial_product = commercial_product.to_s.downcase == 'true'

      product.pricing_url = pricing_url
      product.hosting_model = hosting_model
      product.pricing_model = pricing_model
      product.pricing_details = pricing_details
      product.product_stage = product_stage

      # Only admin will be allowed to set this flag
      product.gov_stack_entity = gov_stack_entity if an_admin

      extra_attributes&.each do |attr|
        product.set_extra_attribute(name: attr[:name], value: attr[:value], type: attr[:type])
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(product)
        product.manual_update = true
        product.save!

        unless image_file.nil?
          uploader = LogoUploader.new(product, image_file.original_filename, context[:current_user])
          begin
            uploader.store!(image_file)
          rescue StandardError => e
            puts "Unable to save image for: #{product.name}. Standard error: #{e}."
          end
          product.auditable_image_changed(image_file.original_filename)
        end

        product_desc = ProductDescription.find_by(product_id: product.id, locale: I18n.locale)
        product_desc = ProductDescription.new if product_desc.nil?
        product_desc.description = description
        product_desc.product_id = product.id
        product_desc.locale = I18n.locale

        assign_auditable_user(product_desc)
        product_desc.save!

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          product:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          product: nil,
          errors: product.errors.full_messages
        }
      end
    end
  end
end
