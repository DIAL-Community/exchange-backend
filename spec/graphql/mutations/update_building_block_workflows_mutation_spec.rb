# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateBuildingBlockWorkflows, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateBuildingBlockWorkflows (
        $workflowSlugs: [String!]!
        $slug: String!
        ) {
          updateBuildingBlockWorkflows (
            workflowSlugs: $workflowSlugs
            slug: $slug
          ) {
            buildingBlock {
              slug
              workflows {
                slug
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    admin_user = create(:user, email: 'admin@gmail.com', roles: [:admin])
    create(:building_block, name: 'Some Name', slug: 'some-name',
                      workflows: [create(:workflow, slug: 'wf_1', name: 'Wf 1')])
    create(:workflow, slug: 'wf_2', name: 'Wf 2')
    create(:workflow, slug: 'wf_3', name: 'Wf 3')

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { workflowSlugs: ['wf_2', 'wf_3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockWorkflows']['buildingBlock'])
        .to(eq({ "slug" => "some-name", "workflows" => [{ "slug" => "wf_2" }, { "slug" => "wf_3" }] }))
      expect(result['data']['updateBuildingBlockWorkflows']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    content_editor_user = create(:user, email: 'admin@gmail.com', roles: [:admin, :content_editor])
    create(:building_block, name: 'Some Name', slug: 'some-name',
                      workflows: [create(:workflow, slug: 'wf_1', name: 'Wf 1')])
    create(:workflow, slug: 'wf_2', name: 'Wf 2')
    create(:workflow, slug: 'wf_3', name: 'Wf 3')

    result = execute_graphql_as_user(
      content_editor_user,
      mutation,
      variables: { workflowSlugs: ['wf_2', 'wf_3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockWorkflows']['buildingBlock'])
        .to(eq({ "slug" => "some-name", "workflows" => [{ "slug" => "wf_2" }, { "slug" => "wf_3" }] }))
      expect(result['data']['updateBuildingBlockWorkflows']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user has not proper rights' do
    create(:building_block, name: 'Some Name', slug: 'some-name',
                     workflows: [create(:workflow, slug: 'wf_1', name: 'Wf 1')])
    create(:workflow, slug: 'wf_2', name: 'Wf 2')
    create(:workflow, slug: 'wf_3', name: 'Wf 3')

    result = execute_graphql(
      mutation,
      variables: { workflowSlugs: ['wf_2', 'wf_3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockWorkflows']['buildingBlock'])
        .to(eq(nil))
      expect(result['data']['updateBuildingBlockWorkflows']['errors'])
        .to(eq(['Editing building block is not allowed.']))
    end
  end

  it 'is fails - user is not logged in' do
    create(:building_block, name: 'Some Name', slug: 'some-name',
                     workflows: [create(:workflow, slug: 'wf_1', name: 'Wf 1')])
    create(:workflow, slug: 'wf_2', name: 'Wf 2')
    create(:workflow, slug: 'wf_3', name: 'Wf 3')

    result = execute_graphql(
      mutation,
      variables: { workflowSlugs: ['wf_2', 'wf_3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateBuildingBlockWorkflows']['buildingBlock'])
        .to(eq(nil))
      expect(result['data']['updateBuildingBlockWorkflows']['errors'])
        .to(eq(['Editing building block is not allowed.']))
    end
  end
end
