# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteDataset, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteDataset ($id: ID!) {
        deleteDataset(id: $id) {
            dataset {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:dataset, id: 1000, name: 'Some Dataset', slug: 'some-dataset')
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteDataset']['dataset'])
        .to(eq({ 'id' => '1000' }))
      expect(result['data']['deleteDataset']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:dataset, id: 1000, name: 'Some Dataset', slug: 'some-dataset')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteDataset']['dataset'])
        .to(be(nil))
      expect(result['data']['deleteDataset']['errors'])
        .to(eq(["Deleting dataset is not allowed."]))
    end
  end
end
