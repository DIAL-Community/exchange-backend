# frozen_string_literal: true

class UpdateColumnResourcesResourceTopic < ActiveRecord::Migration[7.0]
  def change
    add_column(:resources, :resource_topics, :string, array: true, default: [])
    remove_column(:resources, :resource_topic, :string)
  end
end
