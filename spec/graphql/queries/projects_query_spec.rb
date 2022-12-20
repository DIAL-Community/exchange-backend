# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::ProjectsQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query PaginatedProjects(
        $first: Int!,
        $offset: Int!,
        $sectors: [String!],
        $countries: [String!],
        $tags: [String!],
        $projectSortHint: String!
      ) {
        paginatedProjects(
          first: $first
          offsetAttributes: {offset: $offset}
          sectors: $sectors
          countries: $countries
          tags: $tags
          projectSortHint: $projectSortHint
        ) {
          totalCount
          pageInfo {
            endCursor
            startCursor
            hasPreviousPage
            hasNextPage
            __typename
          }
          nodes {
            id
            name
            slug
            organizations {
            id
            slug
            name
            imageFile
            __typename
            }
            products {
            id
            slug
            name
            imageFile
            __typename
            }
            origin {
            slug
            name
            __typename
            }
            __typename
          }
            __typename
        }
      }
    GQL
  end

  it 'returns empty nodes list when user do not pass any values' do
    result = execute_graphql(
      query,
      variables: {
        "first": 5,
        "offset": 0,
        "sectors": [""],
        "countries": [],
        "tags": [],
        "projectSortHint": ""
      }
    )
    expect(result['data']['paginatedProjects']['nodes']).to(eq([]))
  end
end
