# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteTag, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteTag ($id: ID!) {
        deleteTag(id: $id) {
            tag {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:tag, id: 1000, name: 'Some Tag', slug: 'some-tag')
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteTag']['tag'])
        .to(eq({ 'id' => '1000' }))
      expect(result['data']['deleteTag']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:tag, id: 1000, name: 'Some Tag', slug: 'some-tag')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteTag']['tag'])
        .to(be(nil))
      expect(result['data']['deleteTag']['errors'])
        .to(eq(["Deleting tag is not allowed."]))
    end
  end
end
