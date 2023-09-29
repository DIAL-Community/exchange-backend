# frozen_string_literal: true

class AlterTaskTrackerDescriptionDatatype < ActiveRecord::Migration[7.0]
  def up
    change_column(:task_tracker_descriptions, :description, :string)
  end

  def down
    # We're not doing anything here as we want to just keep it as string on rollback too.
  end
end
