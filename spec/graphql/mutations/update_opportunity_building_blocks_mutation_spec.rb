# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOpportunityBuildingBlocks, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation(
        $buildingBlockSlugs: [String!]!
        $slug: String!
      ) {
        updateOpportunityBuildingBlocks(
          buildingBlockSlugs: $buildingBlockSlugs
          slug: $slug
        ) {
          opportunity {
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

  it 'sucesfully adding buildingBlock to the opportunity object' do
    first = create(:building_block, slug: 'first_buildingBlock', name: 'First Building Block')
    second = create(:building_block, slug: 'second_buildingBlock', name: 'Second Building Block')
    opportunity = create(
      :opportunity,
      name: 'Opportunity A',
      description: 'Some description',
      web_address: 'http://example.com',
      opportunity_status: Opportunity.opportunity_status_types[:OPEN],
      opportunity_type: Opportunity.opportunity_type_types[:OTHER],
      contact_name: 'Fake Name',
      contact_email: 'fake@email.com'
    )
    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { buildingBlockSlugs: [first.slug, second.slug], slug: opportunity.slug },
    )

    aggregate_failures do
      expect(result['data']['updateOpportunityBuildingBlocks']['opportunity'])
        .to(eq({
          "buildingBlocks" => [
            { "slug" => first.slug },
            { "slug" => second.slug }
          ],
          "slug" => opportunity.slug
        }))
    end
  end

  it 'should prevent non-admin user to update opportunity record' do
    opportunity = create(
      :opportunity,
      name: 'Opportunity A',
      description: 'Some description',
      web_address: 'http://example.com',
      opportunity_status: Opportunity.opportunity_status_types[:OPEN],
      opportunity_type: Opportunity.opportunity_type_types[:OTHER],
      contact_name: 'Fake Name',
      contact_email: 'fake@email.com'
    )
    first_building_block = create(:building_block, slug: 'first_building_block', name: 'First Building Block')
    second_building_block = create(:building_block, slug: 'second_building_block', name: 'Second Building Block')
    standard_user = create(:user, email: 'user@gmail.com', roles: [:user])

    result = execute_graphql_as_user(
      standard_user,
      mutation,
      variables: {
        buildingBlockSlugs: [first_building_block.slug, second_building_block.slug],
        slug: opportunity.slug
      }
    )

    aggregate_failures do
      expect(result['data']['updateOpportunityBuildingBlocks']['opportunity'])
        .to(eq(nil))
      expect(result['data']['updateOpportunityBuildingBlocks']['errors'])
        .to(eq(['Must have proper rights to update an opportunity']))
    end
  end
end
