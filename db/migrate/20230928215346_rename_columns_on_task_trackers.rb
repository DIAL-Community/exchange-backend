# frozen_string_literal: true

class RenameColumnsOnTaskTrackers < ActiveRecord::Migration[7.0]
  def change
    rename_column(:task_trackers, :last_run, :last_started_date)
    rename_column(:task_trackers, :message, :last_received_message)
  end
end
