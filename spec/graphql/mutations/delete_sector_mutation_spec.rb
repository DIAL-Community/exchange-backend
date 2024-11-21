# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteSector, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteSector ($id: ID!) {
        deleteSector(id: $id) {
            sector {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:sector, id: 1000, name: 'Some Sector', slug: 'some-sector')
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteSector']['sector'])
        .to(eq({ 'id' => '1000' }))
      expect(result['data']['deleteSector']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:sector, id: 1000, name: 'Some Sector', slug: 'some-sector')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteSector']['sector'])
        .to(be(nil))
      expect(result['data']['deleteSector']['errors'])
        .to(eq(["Deleting sector is not allowed."]))
    end
  end
end
