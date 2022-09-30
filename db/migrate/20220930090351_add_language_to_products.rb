# frozen_string_literal: true

class AddLanguageToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column(:products, :languages, :jsonb)
  end
end
