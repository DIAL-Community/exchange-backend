# frozen_string_literal: true

class AddRunStatusToTaskTrackers < ActiveRecord::Migration[7.0]
  def change
    add_column(:task_trackers, :task_completed, :boolean, null: false, default: false)
  end
end
