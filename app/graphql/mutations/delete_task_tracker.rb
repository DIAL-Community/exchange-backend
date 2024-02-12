# frozen_string_literal: true

module Mutations
  class DeleteTaskTracker < Mutations::BaseMutation
    argument :id, ID, required: true

    field :task_tracker, Types::TaskTrackerType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          task_tracker: nil,
          errors: ['Must be admin to delete a task_tracker.']
        }
      end

      task_tracker = TaskTracker.find_by(id:)
      if task_tracker.nil?
        return {
          task_tracker: nil,
          errors: ['Unable to uniquely identify task_tracker to delete.']
        }
      end
      assign_auditable_user(task_tracker)

      successful_operation = false
      ActiveRecord::Base.transaction do
        task_tracker.destroy!
        successful_operation = true
      end

      if successful_operation
        # Successful deletion, return the deleted task_tracker with no errors
        {
          task_tracker:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client.
        {
          task_tracker: nil,
          errors: task_tracker.errors.full_messages
        }
      end
    end
  end
end
