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

    argument :synchronized_models, [String], required: true

    field :sync, Types::SyncType, null: true
    field :errors, [String], null: true

    def resolve(slug:, name:, description:, source:, destination:, synchronized_models:)
      # Prevent duplicating sync by the name of the sync.
      sync = TenantSyncConfiguration.find_by(slug:)
      sync = TenantSyncConfiguration.find_by(name:) if sync.nil?
      sync_policy = Pundit.policy(context[:current_user], SiteSetting.new)
      if sync.nil? && !sync_policy.create_allowed?
        return {
          sync: nil,
          errors: ['Creating / editing sync is not allowed.']
        }
      end

      if !sync.nil? && !sync_policy.edit_allowed?
        return {
          sync: nil,
          errors: ['Creating / editing sync is not allowed.']
        }
      end

      if sync.nil?
        sync = TenantSyncConfiguration.new(name:, slug: reslug_em(name))

        # Check if we need to add _dup to the slug.
        first_duplicate = TenantSyncConfiguration.slug_simple_starts_with(sync.slug)
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
      sync.sync_configuration['models'] = synchronized_models

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
