# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOpportunityOrganizations, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateOpportunityOrganizations (
        $organizationSlugs: [String!]!
        $slug: String!
      ) {
        updateOpportunityOrganizations (
          organizationSlugs: $organizationSlugs
          slug: $slug
        ) {
          opportunity {
            slug
            organizations {
              slug
            }
          }
          errors
        }
      }
    GQL
  end

  it 'should allow admin user to update opportunity record' do
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
    first_organization = create(:organization, slug: 'first_organization', name: 'First Organization')
    second_organization = create(:organization, slug: 'second_organization', name: 'Second Organization')
    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        organizationSlugs: [first_organization.slug, second_organization.slug],
        slug: opportunity.slug
      }
    )

    aggregate_failures do
      expect(result['data']['updateOpportunityOrganizations']['opportunity'])
        .to(eq({
          "slug" => opportunity.slug,
          "organizations" => [
            { "slug" => first_organization.slug },
            { "slug" => second_organization.slug }
          ]
        }))
      expect(result['data']['updateOpportunityOrganizations']['errors'])
        .to(eq([]))
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
    first_organization = create(:organization, slug: 'first_organization', name: 'First Organization')
    second_organization = create(:organization, slug: 'second_organization', name: 'Second Organization')
    standard_user = create(:user, email: 'user@gmail.com', roles: [:user])

    result = execute_graphql_as_user(
      standard_user,
      mutation,
      variables: {
        organizationSlugs: [first_organization.slug, second_organization.slug],
        slug: opportunity.slug
      }
    )

    aggregate_failures do
      expect(result['data']['updateOpportunityOrganizations']['opportunity'])
        .to(eq(nil))
      expect(result['data']['updateOpportunityOrganizations']['errors'])
        .to(eq(['Must have proper rights to update an opportunity']))
    end
  end
end
