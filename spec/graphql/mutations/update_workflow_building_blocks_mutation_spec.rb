# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateWorkflowBuildingBlocks, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateWorkflowBuildingBlocks (
        $buildingBlockSlugs: [String!]!
        $slug: String!
        ) {
          updateWorkflowBuildingBlocks (
            buildingBlockSlugs: $buildingBlockSlugs
            slug: $slug
          ) {
            workflow {
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
    create(
      :workflow,
      name: 'Some Name',
      slug: 'some-name',
      building_blocks: [create(:building_block, slug: 'building-block-1', name: 'Building Block 1')]
    )
    create(:building_block, slug: 'building-block-2', name: 'Building Block 2')
    create(:building_block, slug: 'building-block-3', name: 'Building Block 3')

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { buildingBlockSlugs: ['building-block-2', 'building-block-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateWorkflowBuildingBlocks']['workflow'])
        .to(eq({
          "slug" => "some-name",
          "buildingBlocks" => [{ "slug" => "building-block-2" }, { "slug" => "building-block-3" }]
        }))
      expect(result['data']['updateWorkflowBuildingBlocks']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    create(
      :workflow,
      name: 'Some Name',
      slug: 'some-name',
      building_blocks: [create(:building_block, slug: 'building-block-1', name: 'Building Block 1')]
    )
    create(:building_block, slug: 'building-block-2', name: 'Building Block 2')
    create(:building_block, slug: 'building-block-3', name: 'Building Block 3')

    editor_user = create(:user, email: 'editor-user@gmail.com', roles: ['content_editor'])

    result = execute_graphql_as_user(
      editor_user,
      mutation,
      variables: { buildingBlockSlugs: ['building-block-2', 'building-block-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateWorkflowBuildingBlocks']['workflow'])
        .to(eq({
          "slug" => "some-name",
          "buildingBlocks" => [{ "slug" => "building-block-2" }, { "slug" => "building-block-3" }]
        }))
      expect(result['data']['updateWorkflowBuildingBlocks']['errors']).to(eq([]))
    end
  end

  it 'is fails - user has not proper rights' do
    create(
      :workflow,
      name: 'Some Name',
      slug: 'some-name',
      building_blocks: [create(:building_block, slug: 'building-block-1', name: 'Building Block 1')]
    )
    create(:building_block, slug: 'building-block-2', name: 'Building Block 2')
    create(:building_block, slug: 'building-block-3', name: 'Building Block 3')

    result = execute_graphql(
      mutation,
      variables: { buildingBlockSlugs: ['building-block-2', 'building-block-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateWorkflowBuildingBlocks']['workflow']).to(eq(nil))
      expect(result['data']['updateWorkflowBuildingBlocks']['errors'])
        .to(eq(['Editing workflow is not allowed.']))
    end
  end

  it 'is fails - user is not logged in' do
    create(
      :workflow,
      name: 'Some Name',
      slug: 'some-name',
      building_blocks: [create(:building_block, slug: 'building-block-1', name: 'Building Block 1')]
    )
    create(:building_block, slug: 'building-block-2', name: 'Building Block 2')
    create(:building_block, slug: 'building-block-3', name: 'Building Block 3')

    result = execute_graphql(
      mutation,
      variables: { buildingBlockSlugs: ['building-block-2', 'building-block-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateWorkflowBuildingBlocks']['workflow']).to(eq(nil))
      expect(result['data']['updateWorkflowBuildingBlocks']['errors'])
        .to(eq(['Editing workflow is not allowed.']))
    end
  end
end
