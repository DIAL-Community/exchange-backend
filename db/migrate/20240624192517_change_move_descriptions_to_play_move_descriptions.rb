# frozen_string_literal: true

class ChangeMoveDescriptionsToPlayMoveDescriptions < ActiveRecord::Migration[7.0]
  def change
    rename_table(:move_descriptions, :play_move_descriptions)
  end
end
