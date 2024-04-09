# frozen_string_literal: true
class AddSubTopics < ActiveRecord::Migration[7.0]
  def change
    add_reference(:resource_topics, :parent_topic, foreign_key: { to_table: :resource_topics, on_delete: :nullify })
  end
end
