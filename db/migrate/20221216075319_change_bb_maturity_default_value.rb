# frozen_string_literal: true

class ChangeBbMaturityDefaultValue < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:building_blocks, :maturity, from: 'BETA', to: 'DRAFT')
  end
end
