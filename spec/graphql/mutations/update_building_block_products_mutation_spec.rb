# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateBuildingBlockProducts, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateBuildingBlockProducts (
        $productSlugs: [String!]!
        $slug: String!
        $mappingStatus: String!
        ) {
          updateBuildingBlockProducts (
            productSlugs: $productSlugs
            slug: $slug
            mappingStatus: $mappingStatus
          ) {
            buildingBlock {
              slug
              products {
                slug
                buildingBlocksMappingStatus
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)
    create(
      :building_block,
      name: 'Some Name',
      slug: 'some-name',
      products: [create(:product, slug: 'product-1', name: 'Product 1')]
    )
    create(:product, slug: 'product-2', name: 'Product 2')
    create(:product, slug: 'product-3', name: 'Product 3')

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: { productSlugs: ['product-2', 'product-3'], slug: 'some-name', mappingStatus: 'VALIDATED' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockProducts']['buildingBlock'])
        .to(eq({
          "slug" => "some-name",
          "products" => [{
            "slug" => "product-2",
            "buildingBlocksMappingStatus" => "VALIDATED"
          }, {
            "slug" => "product-3",
            "buildingBlocksMappingStatus" => "VALIDATED"
          }]
        }))
      expect(result['data']['updateBuildingBlockProducts']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    content_editor = create(:user, email: 'admin@gmail.com', roles: [:admin, :content_editor])
    create(
      :building_block,
      name: 'Some Name',
      slug: 'some-name',
      products: [create(:product, slug: 'product-1', name: 'Product 1')]
    )
    create(:product, slug: 'product-2', name: 'Product 2')
    create(:product, slug: 'product-3', name: 'Product 3')

    result = execute_graphql_as_user(
      content_editor,
      mutation,
      variables: { productSlugs: ['product-2', 'product-3'], slug: 'some-name', mappingStatus: 'BETA' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockProducts']['buildingBlock'])
        .to(eq({
          "slug" => "some-name",
          "products" => [{
            "slug" => "product-2",
            "buildingBlocksMappingStatus" => "BETA"
          }, {
            "slug" => "product-3",
            "buildingBlocksMappingStatus" => "BETA"
          }]
        }))
      expect(result['data']['updateBuildingBlockProducts']['errors']).to(eq([]))
    end
  end

  it 'is fails - user has not proper rights' do
    create(
      :building_block,
      name: 'Some Name',
      slug: 'some-name',
      products: [create(:product, slug: 'product-1', name: 'Prod 1')]
    )
    create(:product, slug: 'product-2', name: 'Product 2')
    create(:product, slug: 'product-3', name: 'Product 3')

    result = execute_graphql(
      mutation,
      variables: { productSlugs: ['product-2', 'product-3'], slug: 'some-name', mappingStatus: 'BETA' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockProducts']['buildingBlock']).to(eq(nil))
      expect(result['data']['updateBuildingBlockProducts']['errors'])
        .to(eq(['Editing building block is not allowed.']))
    end
  end

  it 'is fails - user is not logged in' do
    create(:building_block, name: 'Some Name', slug: 'some-name',
                     products: [create(:product, slug: 'prod_1', name: 'Prod 1')])
    create(:product, slug: 'product-2', name: 'Product 2')
    create(:product, slug: 'product-3', name: 'Product 3')

    result = execute_graphql(
      mutation,
      variables: { productSlugs: ['product-2', 'product-3'], slug: 'some-name', mappingStatus: 'BETA' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockProducts']['buildingBlock']).to(eq(nil))
      expect(result['data']['updateBuildingBlockProducts']['errors'])
        .to(eq(['Editing building block is not allowed.']))
    end
  end
end
