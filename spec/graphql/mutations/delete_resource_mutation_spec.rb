# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteResource, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteResource ($id: ID!) {
        deleteResource(id: $id) {
            resource {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])
    create(:resource, id: 1000, name: 'Some Resource', slug: 'some-resource')

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { id: '1000' }
    )

    aggregate_failures do
      expect(result['data']['deleteResource']['resource']).to(eq({ 'id' => '1000' }))
      expect(result['data']['deleteResource']['errors']).to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:resource, id: 1000, name: 'Some Resource', slug: 'some-resource')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' }
    )

    aggregate_failures do
      expect(result['data']['deleteResource']['resource']).to(be(nil))
      expect(result['data']['deleteResource']['errors']).to(eq(["Deleting resource is not allowed."]))
    end
  end
end
