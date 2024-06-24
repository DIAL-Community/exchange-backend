# frozen_string_literal: true
require 'modules/slugger'

module Mutations
  class CreatePage < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :description, String, required: true
    argument :phase, String, required: true
    argument :order, Integer, required: true
    argument :handbook_id, Integer, required: true

    field :page, Types::HandbookPageType, null: false
    field :errors, [String], null: false

    def resolve(name:, description:, phase:, order:, handbook_id:)
      handbook_page = HandbookPage.new(name:, description:, phase:, order:,
                                       handbook_id:)
      handbook_page.slug = reslug_em(name)
      if handbook_page.save
        # Successful creation, return the created object with no errors
        {
          handbook_page:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          handbook_page: nil,
          errors: user.errors.full_messages
        }
      end
    end
  end
end
