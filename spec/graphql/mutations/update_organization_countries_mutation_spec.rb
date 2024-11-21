# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOrganizationCountries, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation($countrySlugs: [String!]!, $slug: String!) {
        updateOrganizationCountries(
          countrySlugs: $countrySlugs
          slug: $slug
        ) {
          organization {
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

  it 'is successful' do
    first = create(:country, slug: 'first_country', name: 'First Country')
    second = create(:country, slug: 'second_country', name: 'Second Country')

    organization = create(:organization, name: 'Graph Organization', slug: 'graph_organization')

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { countrySlugs: [first.slug, second.slug], slug: organization.slug },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationCountries']['organization'])
        .to(eq({ "countries" => [{ "slug" => first.slug }, { "slug" => second.slug }], "slug" => organization.slug }))
    end
  end
end
