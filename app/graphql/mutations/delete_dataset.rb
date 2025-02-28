# frozen_string_literal: true

module Mutations
  class DeleteDataset < Mutations::BaseMutation
    argument :id, ID, required: true

    field :dataset, Types::DatasetType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      dataset = Dataset.find_by(id:)
      dataset_policy = DatasetPolicy.new(context[:current_user], dataset || Dataset.new)
      if dataset.nil? || !dataset_policy.delete_allowed?
        return {
          dataset: nil,
          errors: ['Deleting dataset is not allowed.']
        }
      end

      assign_auditable_user(dataset)
      if dataset.destroy
        # Successful deletion, return the deleted dataset with no errors
        {
          dataset:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          dataset: nil,
          errors: dataset.errors.full_messages
        }
      end
    end
  end
end
