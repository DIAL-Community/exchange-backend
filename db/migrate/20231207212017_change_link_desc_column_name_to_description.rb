# frozen_string_literal: true

class ChangeLinkDescColumnNameToDescription < ActiveRecord::Migration[7.0]
  def change
    rename_column(:resources, :link_desc, :link_description)
  end
end
