# frozen_string_literal: true

module Queries
  class AuthorQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::AuthorType, null: true

    def resolve(slug:)
      Author.find_by(slug:)
    end
  end

  class AuthorsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::AuthorType], null: false

    def resolve(search:)
      authors = Author.order(:name)
      authors = authors.name_contains(search) unless search.blank?
      authors
    end
  end
end
