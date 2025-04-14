# frozen_string_literal: true

class ChangeDefaultContactExtraAttributesToArray < ActiveRecord::Migration[7.1]
  def change
    change_column_default(:contacts, :extra_attributes, from: {}, to: [])
  end
end
