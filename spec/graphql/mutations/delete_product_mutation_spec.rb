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
    create(:product, id: 1000, name: 'Some Product', slug: 'some_product')
    expect_any_instance_of(Mutations::DeleteProduct).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
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
    create(:product, id: 1000, name: 'Some Product', slug: 'some_product')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteProduct']['product'])
        .to(be(nil))
      expect(result['data']['deleteProduct']['errors'])
        .to(eq(["Must be admin to delete a product."]))
    end
  end
end
