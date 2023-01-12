# frozen_string_literal: true

module Mutations
  class DeleteDataset < Mutations::BaseMutation
    argument :id, ID, required: true

    field :dataset, Types::DatasetType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          dataset: nil,
          errors: ['Must be admin to delete a dataset.']
        }
      end

      dataset = Dataset.find_by(id: id)
      assign_auditable_user(dataset)
      if dataset.destroy
        # Successful deletion, return the nil dataset with no errors
        {
          dataset: dataset,
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
