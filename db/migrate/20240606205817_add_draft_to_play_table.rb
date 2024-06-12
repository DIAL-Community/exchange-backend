# frozen_string_literal: true

class AddDraftToPlayTable < ActiveRecord::Migration[7.0]
  def change
    add_column(:plays, :draft, :boolean, default: false)
  end
end
