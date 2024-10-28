# frozen_string_literal: true

module Queries
  class AuthorQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::AuthorType, null: true

    def resolve(slug:)
      author = Author.find_by(slug:) if valid_slug?(slug)
      validate_access_to_instance(author || Author.new)
      author
    end
  end

  class AuthorsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::AuthorType], null: false

    def resolve(search:)
      validate_access_to_resource(Author.new)
      authors = Author.order(:name)
      authors = authors.name_contains(search) unless search.blank?
      authors
    end
  end
end
