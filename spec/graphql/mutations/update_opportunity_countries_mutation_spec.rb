# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOpportunityCountries, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation($countrySlugs: [String!]!, $slug: String!) {
        updateOpportunityCountries(countrySlugs: $countrySlugs, slug: $slug) {
          opportunity {
            slug
            countries {
              slug
            }
          }
          errors
        }
      }
    GQL
  end

  it 'sucesfully adding country to the opportunity object' do
    first = create(:country, slug: 'first_country', name: 'First Country')
    second = create(:country, slug: 'second_country', name: 'Second Country')
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
      variables: { countrySlugs: [first.slug, second.slug], slug: opportunity.slug },
    )

    aggregate_failures do
      expect(result['data']['updateOpportunityCountries']['opportunity'])
        .to(eq({
          "countries" => [
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
    first_country = create(:country, slug: 'first_country', name: 'First Country')
    second_country = create(:country, slug: 'second_country', name: 'Second Country')
    standard_user = create(:user, email: 'user@gmail.com', roles: [:user])

    result = execute_graphql_as_user(
      standard_user,
      mutation,
      variables: {
        countrySlugs: [first_country.slug, second_country.slug],
        slug: opportunity.slug
      }
    )

    aggregate_failures do
      expect(result['data']['updateOpportunityCountries']['opportunity']).to(eq(nil))
      expect(result['data']['updateOpportunityCountries']['errors'])
        .to(eq(['Editing opportunity is not allowed.']))
    end
  end
end
