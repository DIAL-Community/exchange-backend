# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProductBuildingBlocks, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProductBuildingBlocks (
        $buildingBlocksSlugs: [String!]!
        $slug: String!
        ) {
          updateProductBuildingBlocks (
            buildingBlocksSlugs: $buildingBlocksSlugs
            slug: $slug
          ) {
            product {
              slug
              buildingBlocks {
                slug
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:product, name: 'Some Name', slug: 'some_name',
                     building_blocks: [create(:building_block, slug: 'bb_1', name: 'BB 1')])
    create(:building_block, slug: 'bb_2', name: 'BB 2')
    create(:building_block, slug: 'bb_3', name: 'BB 3')
    expect_any_instance_of(Mutations::UpdateProductBuildingBlocks).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { buildingBlocksSlugs: ['bb_2', 'bb_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProductBuildingBlocks']['product'])
        .to(eq({ "slug" => "some_name", "buildingBlocks" => [{ "slug" => "bb_2" }, { "slug" => "bb_3" }] }))
      expect(result['data']['updateProductBuildingBlocks']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:product, name: 'Some Name', slug: 'some_name',
                     building_blocks: [create(:building_block, slug: 'bb_1', name: 'BB 1')])
    create(:building_block, slug: 'bb_2', name: 'BB 2')
    create(:building_block, slug: 'bb_3', name: 'BB 3')

    result = execute_graphql(
      mutation,
      variables: { buildingBlocksSlugs: ['bb_2', 'bb_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProductBuildingBlocks']['product'])
        .to(eq(nil))
      expect(result['data']['updateProductBuildingBlocks']['errors'])
        .to(eq(['Must be admin or product owner to update a product']))
    end
  end
end