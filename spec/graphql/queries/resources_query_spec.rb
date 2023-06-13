# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::ResourcesQuery, type: :graphql) do
  let(:resource_query) do
    <<~GQL
      query SearchResources(
        $first: Int
        $after: String
        $search: String
        $showInExchange: Boolean
        $showInWizard: Boolean
      ) {
        searchResources(
          first: $first
          after: $after
          search: $search
          showInExchange: $showInExchange
          showInWizard: $showInWizard
        ) {
          totalCount
          pageInfo {
            endCursor
            startCursor
            hasPreviousPage
            hasNextPage
          }
          nodes {
            name
            slug
            showInExchange
            showInWizard
          }
        }
      }
    GQL
  end

  it 'Searching by resource name.' do
    create(:resource, id: 1001, name: 'Resource A', slug: 'resource_a')
    create(:resource, id: 1002, name: 'Resource B', slug: 'resource_b')
    result = execute_graphql(
      resource_query
    )

    aggregate_failures do
      # 2 resources from here
      expect(result['data']['searchResources']['totalCount']).to(eq(2))
    end

    # Passing parameter to search will filter search result.
    result = execute_graphql(
      resource_query,
      variables: { search: 'Resource A' }
    )

    aggregate_failures do
      expect(result['data']['searchResources']['totalCount']).to(eq(1))
      expect(result['data']['searchResources']['nodes'])
        .to(eq([{ 'name' => 'Resource A', 'slug' => 'resource_a', 'showInExchange' => false,
                  'showInWizard' => false }]))
    end
  end

  it 'Searching exchange only resources.' do
    create(:resource, id: 1001, name: 'Resource A', slug: 'resource_a', show_in_exchange: true)
    create(:resource, id: 1002, name: 'Resource B', slug: 'resource_b', show_in_exchange: false)
    result = execute_graphql(
      resource_query,
      variables: { showInExchange: true }
    )

    aggregate_failures do
      expect(result['data']['searchResources']['totalCount']).to(eq(1))
      expect(result['data']['searchResources']['nodes'])
        .to(eq([{ 'name' => 'Resource A', 'slug' => 'resource_a', 'showInExchange' => true, 'showInWizard' => false }]))
    end
  end

  it 'Searching wizard only resources.' do
    create(:resource, id: 1001, name: 'Resource A', slug: 'resource_a', show_in_wizard: true)
    create(:resource, id: 1002, name: 'Resource B', slug: 'resource_b', show_in_wizard: false)
    result = execute_graphql(
      resource_query,
      variables: { showInWizard: true }
    )

    aggregate_failures do
      expect(result['data']['searchResources']['totalCount']).to(eq(1))
      expect(result['data']['searchResources']['nodes'])
        .to(eq([{ 'name' => 'Resource A', 'slug' => 'resource_a', 'showInExchange' => false, 'showInWizard' => true }]))
    end
  end
end
