# frozen_string_literal: true

class AddFieldShowInWizardInResources < ActiveRecord::Migration[7.0]
  def change
    add_column(:resources, :show_in_wizard, :boolean, null: false, default: true)
  end
end
