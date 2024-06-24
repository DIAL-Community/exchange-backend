# frozen_string_literal: true

class RenamePlayMovesResourcesToInlineResources < ActiveRecord::Migration[7.0]
  def change
    rename_column(:play_moves, :resources, :inline_resources)
  end
end
