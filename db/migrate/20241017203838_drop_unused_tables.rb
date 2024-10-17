# frozen_string_literal: true

class DropUnusedTables < ActiveRecord::Migration[7.0]
  def up
    drop_table(:stylesheets, if_exists: true)
    drop_table(:portal_views, if_exists: true)

    drop_table(:plays_subplays, if_exists: true)
  end

  def down
    # Nothing to do as we're just gonna just delete the tables.
  end
end
