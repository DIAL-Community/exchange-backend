# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateCity < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :name, String, required: true

    field :city, Types::CityType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:)
      unless an_admin
        return {
          city: nil,
          errors: ['Must be an admin to create / edit a city']
        }
      end

      city = City.find_by(slug:)
      city = City.find_by(name:) if city.nil?
      city = City.new(name:, slug: slug_em(name)) if city.nil?

      successful_operation = false
      ActiveRecord::Base.transaction do
        city.name = name
        assign_auditable_user(city)
        city.save

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          city:,
          errors: []
        }
      else
        # Failed save, return the errors to the client.
        # We will only reach this block if the transaction is failed.
        {
          city: nil,
          errors: city.errors.full_messages
        }
      end
    end
  end
end
