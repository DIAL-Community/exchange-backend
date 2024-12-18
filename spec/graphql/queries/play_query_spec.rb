# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::PlayQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query($owner: String!) {
        plays(owner: $owner) {
          id
          slug
          name
        }
      }
    GQL
  end

  it 'pulling plays is successful' do
    create(:play, name: 'Some Play', owned_by: 'Some Owner')
    create(:play, name: 'Some More Play', owned_by: 'Some Owner')
    create(:play, name: 'Yet More Play', owned_by: 'Some Owner')
    create(:play, name: 'Another Play', owned_by: 'Some Other Owner')

    result = execute_graphql(
      query,
      variables: { "owner": "Some Owner" }
    )

    aggregate_failures do
      expect(result['data']['plays'].count).to(eq(3))
    end
  end
end

RSpec.describe(Queries::SearchPlaysQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query
        SearchPlays(
          $search: String
          $products: [String!]
          $owner: String!
          $after: String
          $before: String
          $first: Int
          $last: Int
        ) {
          searchPlays (
            search: $search
            products: $products
            owner: $owner
            after: $after
            before: $before
            first: $first
            last: $last
          ) {
            totalCount
            pageInfo {
              endCursor
              startCursor
              hasPreviousPage
              hasNextPage
            }
            nodes {
              id
              slug
              name
            }
          }
        }
    GQL
  end

  it 'searching plays is successful' do
    create(:play, name: 'Some Play', owned_by: "Some Owner")

    result = execute_graphql(
      query,
      variables: { "search": "Some", "owner": "Some Owner" }
    )

    aggregate_failures do
      expect(result['data']['searchPlays']['totalCount']).to(eq(1))
    end
  end

  it 'searching plays fails' do
    result = execute_graphql(
      query,
      variables: { search: "Whatever which does not exist", owner: "Some Owner" }
    )

    aggregate_failures do
      expect(result['data']['searchPlays']['totalCount']).to(eq(0))
    end
  end
end
