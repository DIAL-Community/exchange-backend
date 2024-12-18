# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProjectProducts, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation($productSlugs: [String!]!, $slug: String!) {
        updateProjectProducts(
          productSlugs: $productSlugs
          slug: $slug
        ) {
          project {
            slug
            products {
              slug
            }
          }
          errors
        }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(
      :project,
      name: 'Some Name',
      slug: 'some-name',
      products: [create(:product, slug: 'product-1', name: 'Product 1')]
    )
    create(:product, slug: 'product-2', name: 'Product 2')
    create(:product, slug: 'product-3', name: 'Product 3')

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { productSlugs: ['product-2', 'product-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectProducts']['project'])
        .to(eq({ "slug" => "some-name", "products" => [{ "slug" => "product-2" }, { "slug" => "product-3" }] }))
      expect(result['data']['updateProjectProducts']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as product owner' do
    create(
      :project,
      name: 'Some Name',
      slug: 'some-name',
      products: [create(:product, id: 10001, slug: 'product-1', name: 'Product 1')]
    )
    create(:product, id: 10002, slug: 'product-2', name: 'Product 2')
    create(:product, id: 10003, slug: 'product-3', name: 'Product 3')

    owner_user = create(
      :user,
      email: 'user@gmail.com',
      roles: ['product_owner'],
      user_products: [10001]
    )

    result = execute_graphql_as_user(
      owner_user,
      mutation,
      variables: { productSlugs: ['product-2', 'product-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectProducts']['project'])
        .to(eq({ "slug" => "some-name", "products" => [{ "slug" => "product-2" }, { "slug" => "product-3" }] }))
      expect(result['data']['updateProjectProducts']['errors']).to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(
      :project,
      name: 'Some Name',
      slug: 'some-name',
      products: [create(:product, slug: 'product-1', name: 'Product 1')]
    )
    create(:product, slug: 'product-2', name: 'Product 2')
    create(:product, slug: 'product-3', name: 'Product 3')

    result = execute_graphql(
      mutation,
      variables: { productSlugs: ['product-2', 'product-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectProducts']['project']).to(eq(nil))
      expect(result['data']['updateProjectProducts']['errors'])
        .to(eq(['Editing project is not allowed.']))
    end
  end
end
