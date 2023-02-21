# frozen_string_literal: true

module Types
  class CandidateProductType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :website, String, null: false
    field :repository, String, null: false
    field :submitter_email, String, null: false
    field :description, String, null: true

    field :commercial_product, Boolean, null: false

    field :rejected, Boolean, null: true
  end
end
