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
    expect_any_instance_of(Mutations::UpdateBuildingBlockProducts).to(receive(:an_admin).and_return(true))

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: { productSlugs: ['product-2', 'product-3'], slug: 'some-name', mappingStatus: 'VALIDATED' },
    )

    puts "Result: #{result.inspect}"

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
    create(
      :building_block,
      name: 'Some Name',
      slug: 'some-name',
      products: [create(:product, slug: 'product-1', name: 'Product 1')]
    )
    create(:product, slug: 'product-2', name: 'Product 2')
    create(:product, slug: 'product-3', name: 'Product 3')
    expect_any_instance_of(Mutations::UpdateBuildingBlockProducts).to(receive(:a_content_editor).and_return(true))

    result = execute_graphql(
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
    expect_any_instance_of(Mutations::UpdateBuildingBlockProducts).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::UpdateBuildingBlockProducts).to(receive(:a_content_editor).and_return(false))

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
        .to(eq(['Must be admin or content editor to update building block']))
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
        .to(eq(['Must be admin or content editor to update building block']))
    end
  end
end
