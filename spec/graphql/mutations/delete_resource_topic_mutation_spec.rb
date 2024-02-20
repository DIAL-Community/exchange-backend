# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteResourceTopic, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteResourceTopic ($id: ID!) {
        deleteResourceTopic(id: $id) {
            resourceTopic {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:resource_topic, id: 1000, name: 'Some Resource Topic', slug: 'some-resource-topic')
    admin = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin,
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteResourceTopic']['resourceTopic'])
        .to(eq({ 'id' => '1000' }))
      expect(result['data']['deleteResourceTopic']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:resource_topic, id: 1000, name: 'Some Resource Topic', slug: 'some-resource-topic')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteResourceTopic']['resourceTopic'])
        .to(be(nil))
      expect(result['data']['deleteResourceTopic']['errors'])
        .to(eq(["Must be admin to delete a resource topic."]))
    end
  end
end
