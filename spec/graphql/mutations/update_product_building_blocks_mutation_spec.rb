# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProductBuildingBlocks, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProductBuildingBlocks (
        $buildingBlockSlugs: [String!]!
        $slug: String!
        $mappingStatus: String!
        ) {
          updateProductBuildingBlocks (
            buildingBlockSlugs: $buildingBlockSlugs
            slug: $slug
            mappingStatus: $mappingStatus
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
    create(:product, name: 'Some Name', slug: 'some-name',
                     building_blocks: [create(:building_block, slug: 'bb_1', name: 'BB 1')])
    create(:building_block, slug: 'bb_2', name: 'BB 2')
    create(:building_block, slug: 'bb_3', name: 'BB 3')

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { buildingBlockSlugs: ['bb_2', 'bb_3'], slug: 'some-name', mappingStatus: 'VALIDATED' },
    )

    aggregate_failures do
      expect(result['data']['updateProductBuildingBlocks']['product'])
        .to(eq({ "slug" => "some-name", "buildingBlocks" => [{ "slug" => "bb_2" }, { "slug" => "bb_3" }] }))
      expect(result['data']['updateProductBuildingBlocks']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:product, name: 'Some Name', slug: 'some-name',
                     building_blocks: [create(:building_block, slug: 'bb_1', name: 'BB 1')])
    create(:building_block, slug: 'bb_2', name: 'BB 2')
    create(:building_block, slug: 'bb_3', name: 'BB 3')

    result = execute_graphql(
      mutation,
      variables: { buildingBlockSlugs: ['bb_2', 'bb_3'], slug: 'some-name', mappingStatus: 'VALIDATED' },
    )

    aggregate_failures do
      expect(result['data']['updateProductBuildingBlocks']['product'])
        .to(eq(nil))
      expect(result['data']['updateProductBuildingBlocks']['errors'])
        .to(eq(['Editing product is not allowed.']))
    end
  end
end
