# frozen_string_literal: true

class ResourceTopicDescription < ApplicationRecord
  include Auditable
  belongs_to(:resource_topic)
end
