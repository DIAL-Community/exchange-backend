# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteOpportunity, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteOpportunity ($id: ID!) {
        deleteOpportunity(id: $id) {
            opportunity {
              id
              name
              slug
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(
      :opportunity,
      id: '1000',
      name: 'Opportunity A',
      description: 'Some description',
      web_address: 'http://example.com',
      opportunity_status: Opportunity.opportunity_status_types[:OPEN],
      opportunity_type: Opportunity.opportunity_type_types[:OTHER],
      contact_name: 'Fake Name',
      contact_email: 'fake@email.com'
    )
    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteOpportunity']['opportunity']['id'])
        .to(eq('1000'))
      expect(result['data']['deleteOpportunity']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(
      :opportunity,
      id: '1000',
      name: 'Opportunity A',
      description: 'Some description',
      web_address: 'http://example.com',
      opportunity_status: Opportunity.opportunity_status_types[:OPEN],
      opportunity_type: Opportunity.opportunity_type_types[:OTHER],
      contact_name: 'Fake Name',
      contact_email: 'fake@email.com'
    )
    standard_user = create(:user, email: 'user@gmail.com', roles: [:user])

    result = execute_graphql_as_user(
      standard_user,
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteOpportunity']['opportunity'])
        .to(be(nil))
      expect(result['data']['deleteOpportunity']['errors'])
        .to(eq(["Must be admin to delete an opportunity"]))
    end
  end
end
