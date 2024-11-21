# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProjectCountries, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProjectCountries (
        $countrySlugs: [String!]!
        $slug: String!
        ) {
          updateProjectCountries (
            countrySlugs: $countrySlugs
            slug: $slug
          ) {
            project {
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

  it 'is successful - user is logged in as admin' do
    create(
      :project,
      name: 'Some Name',
      slug: 'some-name',
      countries: [create(:country, slug: 'country-1', name: 'Country 1')]
    )
    create(:country, slug: 'country-2', name: 'Country 2')
    create(:country, slug: 'country-3', name: 'Country 3')

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { countrySlugs: ['country-2', 'country-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectCountries']['project'])
        .to(eq({ "slug" => "some-name", "countries" => [{ "slug" => "country-2" }, { "slug" => "country-3" }] }))
      expect(result['data']['updateProjectCountries']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as product owner' do
    create(
      :project,
      name: 'Some Name',
      slug: 'some-name',
      countries: [create(:country, slug: 'country-1', name: 'Country 1')],
      organizations: [create(:organization, slug: 'organization-1', name: 'Organization 1')],
      products: [create(:product, id: 1)]
    )
    create(:country, slug: 'country-2', name: 'Country 2')
    create(:country, slug: 'country-3', name: 'Country 3')

    owner_user = create(:user, email: 'user@gmail.com', roles: ['product_owner'], user_products: [1])

    result = execute_graphql_as_user(
      owner_user,
      mutation,
      variables: { countrySlugs: ['country-2', 'country-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectCountries']['project'])
        .to(eq({ "slug" => "some-name", "countries" => [{ "slug" => "country-2" }, { "slug" => "country-3" }] }))
      expect(result['data']['updateProjectCountries']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as organization owner' do
    create(
      :project,
      name: 'Some Name',
      slug: 'some-name',
      countries: [create(:country, slug: 'country-1', name: 'Country 1')],
      organizations: [create(
        :organization,
        id: 10004,
        slug: 'organization-1',
        name: 'Organization 1',
        website: 'website.com'
      )],
      products: [create(:product, id: 1)]
    )
    create(:country, slug: 'country-2', name: 'Country 2')
    create(:country, slug: 'country-3', name: 'Country 3')

    owner_user = create(
      :user,
      email: 'user@website.com',
      roles: ['organization_owner'],
      organization_id: 10004
    )

    result = execute_graphql_as_user(
      owner_user,
      mutation,
      variables: { countrySlugs: ['country-2', 'country-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectCountries']['project'])
        .to(eq({ "slug" => "some-name", "countries" => [{ "slug" => "country-2" }, { "slug" => "country-3" }] }))
      expect(result['data']['updateProjectCountries']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(
      :project,
      name: 'Some Name',
      slug: 'some-name',
      countries: [create(:country, slug: 'country-1', name: 'Country 1')]
    )
    create(:country, slug: 'country-2', name: 'Country 2')
    create(:country, slug: 'country-3', name: 'Country 3')

    result = execute_graphql(
      mutation,
      variables: { countrySlugs: ['country-2', 'country-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectCountries']['project']).to(eq(nil))
      expect(result['data']['updateProjectCountries']['errors'])
        .to(eq(['Editing project is not allowed.']))
    end
  end
end
