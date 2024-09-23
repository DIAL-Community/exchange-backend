# frozen_string_literal: true

module Mutations
  class DeleteSiteSetting < Mutations::BaseMutation
    argument :id, ID, required: true

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          site_setting: nil,
          errors: ['Must be admin to delete a site setting.']
        }
      end

      site_setting = SiteSetting.find_by(id:)
      if site_setting.nil?
        return {
          site_setting: nil,
          errors: ['Unable to uniquely identify site setting to delete.']
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
