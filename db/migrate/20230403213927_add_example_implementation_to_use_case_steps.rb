# frozen_string_literal: true

class AddExampleImplementationToUseCaseSteps < ActiveRecord::Migration[6.1]
  def change
    add_column(:use_case_steps, :example_implementation, :string, null: true)
  end
end
