# frozen_string_literal: true

module Mutations
  class DeleteCity < Mutations::BaseMutation
    argument :id, ID, required: true

    field :city, Types::CityType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      city = City.find_by(id:)
      city_policy = Pundit.policy(context[:current_user], city || City.new)
      if city.nil? || !city_policy.delete_allowed?
        return {
          city: nil,
          errors: ['Deleting city is not allowed.']
        }
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(city)
        city.destroy!
        successful_operation = true
      end

      if successful_operation
        # Successful deletion, return the deleted city with no errors
        {
          city:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client.
        {
          city: nil,
          errors: city.errors.full_messages
        }
      end
    end
  end
end
