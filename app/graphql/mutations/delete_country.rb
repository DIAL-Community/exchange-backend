# frozen_string_literal: true

module Mutations
  class DeleteCountry < Mutations::BaseMutation
    argument :id, ID, required: true

    field :country, Types::CountryType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      country = Country.find_by(id:)
      country_policy = Pundit.policy(context[:current_user], country || Country.new)
      if country.nil? || !country_policy.delete_allowed?
        return {
          country: nil,
          errors: ['Deleting country is not allowed.']
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
