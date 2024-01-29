# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateProduct, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateProduct(
        $name: String!,
        $slug: String!,
        $description: String!
        $govStackEntity: Boolean
      ) {
        createProduct(
          name: $name,
          slug: $slug,
          aliases: {},
          website: "somewebsite.org",
          description: $description
          govStackEntity: $govStackEntity
        ) {
            product {
              name
              slug
              govStackEntity
              productDescription {
                description
              }
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    admin_user = create(:user, email: 'admin@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        description: "Some description"
      }
    )

    aggregate_failures do
      expect(result['data']['createProduct']['product'])
        .to(eq({
          "name" => "Some name",
          "govStackEntity" => false,
          "productDescription" => { "description" => "Some description" },
          "slug" => "some-name"
        }))
      expect(result['data']['createProduct']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - setting gov stack field as admin admin' do
    admin_user = create(:user, email: 'admin@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        description: "Some description",
        govStackEntity: true
      }
    )

    aggregate_failures do
      expect(result['data']['createProduct']['product'])
        .to(eq({
          "name" => "Some name",
          "govStackEntity" => true,
          "productDescription" => { "description" => "Some description" },
          "slug" => "some-name"
        }))
      expect(result['data']['createProduct']['errors'])
        .to(eq([]))
    end
  end

  it 'is failed - setting gov stack field as non admin' do
    created_product = create(:product, name: 'Some Name', slug: 'some-name')
    owner_user = create(:user, email: 'owner@gmail.com', roles: [:product_user], user_products: [created_product.id])

    result = execute_graphql_as_user(
      owner_user,
      mutation,
      variables: {
        name: "Some other name",
        slug: "some-name",
        description: "Some description",
        govStackEntity: true
      }
    )

    aggregate_failures do
      expect(result['data']['createProduct']['product'])
        .to(eq({
          "name" => "Some other name",
          "govStackEntity" => false,
          "productDescription" => { "description" => "Some description" },
          "slug" => "some-name"
        }))
      expect(result['data']['createProduct']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        description: "Some description"
      }
    )

    aggregate_failures do
      expect(result['data']['createProduct']['product'])
        .to(be(nil))
      expect(result['data']['createProduct']['errors'])
        .to(eq(['Must be admin or product owner to create a product']))
    end
  end
end
