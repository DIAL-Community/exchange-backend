# frozen_string_literal: true

module Mutations
  class DeleteCountry < Mutations::BaseMutation
    argument :id, ID, required: true

    field :country, Types::CountryType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          country: nil,
          errors: ['Must be admin to delete a country.']
        }
      end

      country = Country.find_by(id:)
      if country.nil?
        return {
          country: nil,
          errors: ['Unable to uniquely identify country to delete.']
        }
      end

      if country.destroy
        # Successful deletion, return the deleted country with no errors
        {
          country:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client.
        {
          country: nil,
          errors: country.errors.full_messages
        }
      end
    end
  end
end
