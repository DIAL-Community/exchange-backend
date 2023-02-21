# frozen_string_literal: true

class AddRepoToSteps < ActiveRecord::Migration[6.1]
  def change
    add_column(:use_case_steps, :markdown_url, :string)
  end
end
