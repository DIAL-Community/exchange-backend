# frozen_string_literal: true

class AddMarkdownUrlToUseCasesTable < ActiveRecord::Migration[6.1]
  def change
    add_column(:use_cases, :markdown_url, :string, null: true)
  end
end
