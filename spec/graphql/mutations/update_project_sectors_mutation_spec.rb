# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProjectSectors, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProjectSectors (
        $sectorSlugs: [String!]!
        $slug: String!
        ) {
          updateProjectSectors (
            sectorSlugs: $sectorSlugs
            slug: $slug
          ) {
            project {
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

  it 'is successful - user is logged in as admin' do
    create(:project, name: 'Some Name', slug: 'some-name',
sectors: [create(:sector, slug: 'sector-1', name: 'Sector 1')])
    create(:sector, slug: 'sector-2', name: 'Sector 2')
    create(:sector, slug: 'sector-3', name: 'Sector 3')

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { sectorSlugs: ['sector-2', 'sector-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectSectors']['project'])
        .to(eq({ "slug" => "some-name", "sectors" => [{ "slug" => "sector-2" }, { "slug" => "sector-3" }] }))
      expect(result['data']['updateProjectSectors']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as product owner' do
    create(
      :project,
      name: 'Some Name',
      slug: 'some-name',
      sectors: [create(:sector, slug: 'sector-1', name: 'Sector 1')],
      organizations: [create(:organization, id: 10001, slug: 'organization-1', name: 'Organization 1')],
      products: [create(:product, id: 10001)]
    )
    create(:sector, slug: 'sector-2', name: 'Sector 2')
    create(:sector, slug: 'sector-3', name: 'Sector 3')

    owner_user = create(
      :user,
      email: 'user@gmail.com',
      roles: ['product_owner'],
      user_products: [10001]
    )

    result = execute_graphql_as_user(
      owner_user,
      mutation,
      variables: { sectorSlugs: ['sector-2', 'sector-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectSectors']['project'])
        .to(eq({ "slug" => "some-name", "sectors" => [{ "slug" => "sector-2" }, { "slug" => "sector-3" }] }))
      expect(result['data']['updateProjectSectors']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as organization owner' do
    create(
      :project,
      name: 'Some Name',
      slug: 'some-name',
      sectors: [create(:sector, slug: 'sector-1', name: 'Sector 1')],
      organizations: [create(
        :organization,
        id: 10001,
        slug: 'organization-1',
        name: 'Organization 1',
        website: 'website.com'
      )],
      products: [create(:product, id: 10001)]
    )
    create(:sector, slug: 'sector-2', name: 'Sector 2')
    create(:sector, slug: 'sector-3', name: 'Sector 3')

    organization_owner = create(
      :user,
      email: 'user@website.com',
      roles: ['organization_owner'],
      organization_id: 10001
    )

    result = execute_graphql_as_user(
      organization_owner,
      mutation,
      variables: { sectorSlugs: ['sector-2', 'sector-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectSectors']['project'])
        .to(eq({ "slug" => "some-name", "sectors" => [{ "slug" => "sector-2" }, { "slug" => "sector-3" }] }))
      expect(result['data']['updateProjectSectors']['errors']).to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(
      :project, name:
      'Some Name',
      slug: 'some-name',
      sectors: [create(:sector, slug: 'sector-1', name: 'Sector 1')]
    )
    create(:sector, slug: 'sector-2', name: 'Sector 2')
    create(:sector, slug: 'sector-3', name: 'Sector 3')

    result = execute_graphql(
      mutation,
      variables: { sectorSlugs: ['sector-2', 'sector-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectSectors']['project']).to(eq(nil))
      expect(result['data']['updateProjectSectors']['errors'])
        .to(eq(['Editing project is not allowed.']))
    end
  end
end
