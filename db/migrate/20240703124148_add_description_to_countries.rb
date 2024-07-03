# frozen_string_literal: true

class AddDescriptionToCountries < ActiveRecord::Migration[7.0]
  def change
    add_column(:countries, :description, :string, null: true)
  end
end
