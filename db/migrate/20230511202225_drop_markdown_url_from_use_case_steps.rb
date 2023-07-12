# frozen_string_literal: true

class DropMarkdownUrlFromUseCaseSteps < ActiveRecord::Migration[6.1]
  def up
    remove_column(:use_case_steps, :markdown_url)
  end

  def down
    add_column(:use_case_steps, :markdown_url, :string)
  end
end
