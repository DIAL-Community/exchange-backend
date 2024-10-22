# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteBuildingBlock, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteBuildingBlock ($id: ID!) {
        deleteBuildingBlock(id: $id) {
            buildingBlock {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    admin_user = create(:user, email: 'admin@gmail.com', roles: [:admin])
    create(:building_block, id: 1000, name: 'Some Building Block', slug: 'some-building_block')

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteBuildingBlock']['buildingBlock'])
        .to(eq({ 'id' => '1000' }))
      expect(result['data']['deleteBuildingBlock']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:building_block, id: 1000, name: 'Some Building Block', slug: 'some-building_block')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteBuildingBlock']['buildingBlock'])
        .to(be(nil))
      expect(result['data']['deleteBuildingBlock']['errors'])
        .to(eq(["Deleting building block is not allowed."]))
    end
  end
end
