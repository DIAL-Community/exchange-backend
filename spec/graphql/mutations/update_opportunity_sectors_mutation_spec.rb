# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOpportunitySectors, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation($sectorSlugs: [String!]!, $slug: String!) {
        updateOpportunitySectors(sectorSlugs: $sectorSlugs, slug: $slug) {
          opportunity {
            slug
            sectors {
              slug
            }
          }
          errors
        }
      }
    GQL
  end

  it 'is successful' do
    first = create(:sector, slug: 'first_sector', name: 'First Sector', is_displayable: true)
    second = create(:sector, slug: 'second_sector', name: 'Second Sector', is_displayable: true)
    opportunity = create(
      :opportunity,
      id: '1000',
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
      variables: { sectorSlugs: [first.slug, second.slug], slug: opportunity.slug },
    )

    aggregate_failures do
      expect(result['data']['updateOpportunitySectors']['opportunity'])
        .to(eq({
          "sectors" => [
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
    first_sector = create(:sector, slug: 'first_sector', name: 'First Sector')
    second_sector = create(:sector, slug: 'second_sector', name: 'Second Sector')
    standard_user = create(:user, email: 'user@gmail.com', roles: [:user])

    result = execute_graphql_as_user(
      standard_user,
      mutation,
      variables: {
        sectorSlugs: [first_sector.slug, second_sector.slug],
        slug: opportunity.slug
      }
    )

    aggregate_failures do
      expect(result['data']['updateOpportunitySectors']['opportunity'])
        .to(eq(nil))
      expect(result['data']['updateOpportunitySectors']['errors'])
        .to(eq(['Must have proper rights to update an opportunity']))
    end
  end
end
