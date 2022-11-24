# frozen_string_literal: true

class TaskTrackerDescription < ApplicationRecord
  include Auditable

  belongs_to :task_tracker
end
