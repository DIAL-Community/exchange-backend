# frozen_string_literal: true

class CreatePlayMovesResources < ActiveRecord::Migration[7.0]
  def change
    create_table(:play_moves_resources) do |t|
      t.references(:play_move, null: false, foreign_key: true)
      t.references(:resource, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
