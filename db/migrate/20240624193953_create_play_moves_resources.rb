# frozen_string_literal: true

class CreatePlayMovesResources < ActiveRecord::Migration[7.0]
  def change
    create_table(:play_moves_resources) do |t|
      t.references(:play_move, null: false, foreign_key: { to_table: :play_moves })
      t.references(:resource, null: false, foreign_key: { to_table: :resources })

      t.timestamps
    end

    add_index(
      :play_moves_resources,
      [:play_move_id, :resource_id],
      unique: true,
      name: 'index_play_moves_resources'
    )
  end
end
