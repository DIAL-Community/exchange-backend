# frozen_string_literal: true

module Mutations
  class DeleteTaskTracker < Mutations::BaseMutation
    argument :id, ID, required: true

    field :task_tracker, Types::TaskTrackerType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      task_tracker = TaskTracker.find_by(id:)
      task_tracker_policy = Pundit.policy(context[:current_user], task_tracker || TaskTracker.new)
      if task_tracker.nil? || !task_tracker_policy.delete_allowed?
        return {
          task_tracker: nil,
          errors: ['Deleting task tracker is not allowed.']
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
