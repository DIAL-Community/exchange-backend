# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateOpportunity, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateOpportunity(
        $slug: String!,
        $name: String!,
        $webAddress: String!
        $description: String!
        $contactName: String!
        $contactEmail: String!
        $openingDate: ISO8601Date!
        $closingDate: ISO8601Date!
        $opportunityType: String!
        $opportunityStatus: String!
      ) {
        createOpportunity(
          slug: $slug
          name: $name
          webAddress: $webAddress
          description: $description
          contactName: $contactName
          contactEmail: $contactEmail
          openingDate: $openingDate
          closingDate: $closingDate
          opportunityType: $opportunityType
          opportunityStatus: $opportunityStatus
        ) {
            opportunity {
              slug
              name
              description
              webAddress
            }
            errors
          }
        }
    GQL
  end

  it 'should allow admin to create opportunity record' do
    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])
    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        slug: "opportunity_a",
        name: "Opportunity A",
        webAddress: "somewebsite.org",
        description: "Some description",
        contactName: "Some contact",
        contactEmail: "some@contact.com",
        openingDate: "2023-01-01",
        closingDate: "2023-03-03",
        opportunityType: 'BID',
        opportunityStatus: 'OPEN'
      }
    )

    aggregate_failures do
      expect(result['data']['createOpportunity']['opportunity']['name'])
        .to(eq("Opportunity A"))
    end
  end

  it 'should allow admin to edit opportunity record' do
  end

  it 'should allow admin to edit opportunity name and keeping the slug' do
  end

  it 'should not allow user to create opportunity' do
  end
end
