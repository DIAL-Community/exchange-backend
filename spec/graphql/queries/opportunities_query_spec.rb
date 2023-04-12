# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::OpportunitiesQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query Opportunities ($search: String) {
        opportunities (search: $search) {
          id
          name
          slug
          origin {
            name
            slug
          }
          buildingBlocks {
            slug
            name
            imageFile
          }
          organizations {
            slug
            name
          }
          useCases {
            slug
            name
          }
          sectors {
            slug
            name
          }
          countries {
            slug
            name
          }
        }
      }
    GQL
  end

  it 'should search opportunities using partial name.' do
    create(
      :opportunity,
      name: 'Opportunity A',
      description: 'Some description',
      web_address: 'http://example.com',
      opportunity_status: Opportunity.opportunity_status_types[:OPEN],
      opportunity_type: Opportunity.opportunity_type_types[:OTHER],
      contact_name: 'Fake Name',
      contact_email: 'fake@email.com'
    )

    result = execute_graphql(
      query,
      variables: { search: 'Opportunity' }
    )

    aggregate_failures do
      expect(result['data']['opportunities'].length).to(eq(1))
    end
  end

  it 'should search opportunities using random text.' do
    result = execute_graphql(
      query,
      variables: { search: 'Whatever' }
    )

    expect(result['data']['opportunities'].length).to(eq(0))
  end
end

RSpec.describe(Queries::SearchOpportunitiesQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query SearchOpportunities (
        $first: Int
        $after: String
        $sectors: [String!]
        $countries: [String!]
        $organizations: [String!]
        $useCases: [String!]
        $buildingBlocks: [String!]
        $search: String!
      ) {
        searchOpportunities (
          first: $first,
          after: $after,
          sectors: $sectors,
          countries: $countries,
          organizations: $organizations,
          useCases: $useCases
          buildingBlocks: $buildingBlocks
          search: $search
        ) {
          __typename
          totalCount
          pageInfo {
            endCursor
            startCursor
            hasPreviousPage
            hasNextPage
          }
          nodes {
            id
            name
            slug
            origin {
              name
              slug
            }
            buildingBlocks {
              slug
              name
              imageFile
            }
            organizations {
              slug
              name
            }
            useCases {
              slug
              name
            }
            sectors {
              slug
              name
            }
            countries {
              slug
              name
            }
          }
        }
      }
    GQL
  end

  it 'should search opportunities using partial name.' do
    create(
      :opportunity,
      name: 'Opportunity A',
      web_address: 'http://example.com',
      description: 'Some description',
      opportunity_status: Opportunity.opportunity_status_types[:OPEN],
      opportunity_type: Opportunity.opportunity_type_types[:OTHER],
      contact_name: 'Fake Name',
      contact_email: 'fake@email.com'
    )

    result = execute_graphql(
      query,
      variables: { search: 'Opportunity' }
    )

    aggregate_failures do
      expect(result['data']['searchOpportunities']['totalCount']).to(eq(1))
      expect(result['data']['searchOpportunities']['nodes'].count).to(eq(1))
    end
  end

  it 'should search opportunities using random text.' do
    result = execute_graphql(
      query,
      variables: { search: 'Whatever' }
    )

    expect(result['data']['searchOpportunities']['totalCount']).to(eq(0))
  end
end

RSpec.describe(Queries::OpportunityQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query Opportunity($slug: String!) {
        opportunity(slug: $slug) {
            id
            name
            slug
            origin {
              name
              slug
            }
            buildingBlocks {
              slug
              name
              imageFile
            }
            organizations {
              slug
              name
            }
            useCases {
              slug
              name
            }
            sectors {
              slug
              name
            }
            countries {
              slug
              name
            }
        }
      }
    GQL
  end

  it 'find opportunity using slug' do
    create(
      :opportunity,
      slug: 'opportunity_a',
      name: 'Opportunity A',
      description: 'Some description',
      web_address: 'http://example.com',
      opportunity_status: Opportunity.opportunity_status_types[:OPEN],
      opportunity_type: Opportunity.opportunity_type_types[:OTHER],
      contact_name: 'Fake Name',
      contact_email: 'fake@email.com'
    )

    result = execute_graphql(
      query,
      variables: { slug: 'opportunity_a' }
    )

    expect(result['data']['opportunity']['name'])
      .to(eq('Opportunity A'))
  end
end
