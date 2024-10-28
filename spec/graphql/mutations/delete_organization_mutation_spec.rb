# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteOrganization, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteOrganization (
        $id: ID!
        ) {
        deleteOrganization(
          id: $id
        ) {
            organization
            {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:organization, id: 1000, name: 'Some Org', slug: 'some-org', website: 'some.org')
    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteOrganization']['organization']['id'])
        .to(eq('1000'))
      expect(result['data']['deleteOrganization']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:organization, id: 1000, name: 'Some Org', slug: 'some-org', website: 'some.org')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteOrganization']['organization'])
        .to(be(nil))
      expect(result['data']['deleteOrganization']['errors'])
        .to(eq(["Deleting organization is not allowed."]))
    end
  end
end
