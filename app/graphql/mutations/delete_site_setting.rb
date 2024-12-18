# frozen_string_literal: true

module Mutations
  class DeleteSiteSetting < Mutations::BaseMutation
    argument :id, ID, required: true

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      site_setting = SiteSetting.find_by(id:)
      site_setting_policy = Pundit.policy(context[:current_user], site_setting || SiteSetting.new)
      if site_setting.nil? || !site_setting_policy.delete_allowed?
        return {
          site_setting: nil,
          errors: ['Deleting site setting is not allowed.']
        }
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(site_setting)
        site_setting.destroy!
        successful_operation = true
      end

      if successful_operation
        # Successful deletion, return the deleted site_setting with no errors
        {
          site_setting:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client.
        {
          site_setting: nil,
          errors: site_setting.errors.full_messages
        }
      end
    end
  end
end
