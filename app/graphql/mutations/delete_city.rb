# frozen_string_literal: true

module Mutations
  class DeleteCity < Mutations::BaseMutation
    argument :id, ID, required: true

    field :city, Types::CityType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          city: nil,
          errors: ['Must be admin to delete a city.']
        }
      end

      city = City.find_by(id:)
      if city.nil?
        return {
          city: nil,
          errors: ['Unable to uniquely identify city to delete.']
        }
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(city)
        city.destroy
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
