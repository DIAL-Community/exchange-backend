# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteProduct, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteProduct ($id: ID!) {
        deleteProduct(id: $id) {
            product {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:product, id: 1000, name: 'Some Product', slug: 'some-product')
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteProduct']['product'])
        .to(eq({ 'id' => '1000' }))
      expect(result['data']['deleteProduct']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:product, id: 1000, name: 'Some Product', slug: 'some-product')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteProduct']['product'])
        .to(be(nil))
      expect(result['data']['deleteProduct']['errors'])
        .to(eq(["Deleting product is not allowed."]))
    end
  end
end
