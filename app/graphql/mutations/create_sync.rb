# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateSync < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :name, String, required: true
    argument :description, String, required: true

    argument :source, String, required: true
    argument :destination, String, required: true

    field :sync, Types::SyncType, null: true
    field :errors, [String], null: true

    def resolve(slug:, name:, description:, source:, destination:)
      unless an_admin
        return {
          sync: nil,
          errors: ['Must be an admin to create / edit a sync']
        }
      end

      # Prevent duplicating sync by the name of the sync.
      sync = TenantSync.find_by(slug:)
      sync = TenantSync.find_by(name:) if sync.nil?
      if sync.nil?
        sync = TenantSync.new(name:, slug: slug_em(name))

        # Check if we need to add _dup to the slug.
        first_duplicate = TenantSync.slug_simple_starts_with(sync.slug)
                                    .order(slug: :desc)
                                    .first
        unless first_duplicate.nil?
          sync.slug += generate_offset(first_duplicate)
        end
      end

      # Update the sync description using data from the UI.
      sync.description = description

      sync.tenant_source = source
      sync.tenant_destination = destination

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(sync)
        sync.save

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          sync:,
          errors: []
        }
      else
        # Failed save, return the errors to the client.
        # We will only reach this block if the transaction is failed.
        {
          sync: nil,
          errors: sync.errors.full_messages
        }
      end
    end
  end
end
