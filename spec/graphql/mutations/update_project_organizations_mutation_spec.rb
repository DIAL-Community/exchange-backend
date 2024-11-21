# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProjectOrganizations, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProjectOrganizations (
        $organizationSlugs: [String!]!
        $slug: String!
        ) {
          updateProjectOrganizations (
            organizationSlugs: $organizationSlugs
            slug: $slug
          ) {
            project {
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

  it 'is successful - user is logged in as admin' do
    create(
      :project,
      name: 'Some Name',
      slug: 'some-name',
    organizations: [create(:organization, slug: 'organization-1', name: 'Organization 1')]
    )
    create(:organization, slug: 'organization-2', name: 'Organization 2')
    create(:organization, slug: 'organization-3', name: 'Organization 3')

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { organizationSlugs: ['organization-2', 'organization-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectOrganizations']['project'])
        .to(eq({
          "slug" => "some-name",
          "organizations" => [{ "slug" => "organization-2" }, { "slug" => "organization-3" }]
        }))
      expect(result['data']['updateProjectOrganizations']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as organization owner' do
    create(
      :project,
      name: 'Some Name',
      slug: 'some-name',
      organizations: [create(
        :organization,
        id: 10004,
        slug: 'organization-1',
        name: 'Organization 1',
        website: 'website.com'
      )],
      products: [create(:product, id: 1)]
    )
    create(:organization, slug: 'organization-2', name: 'Organization 2')

    owner_user = create(
      :user,
      organization_id: 10004,
      email: 'admin-user@website.com',
      roles: ['organization_owner']
    )

    result = execute_graphql_as_user(
      owner_user,
      mutation,
      variables: { organizationSlugs: ['organization-2'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectOrganizations']['project'])
        .to(eq({ "slug" => "some-name", "organizations" => [{ "slug" => "organization-2" }] }))
      expect(result['data']['updateProjectOrganizations']['errors']).to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(
      :project,
      name: 'Some Name',
      slug: 'some-name',
      organizations: [create(:organization, slug: 'organization-1', name: 'Organization 1')]
    )
    create(:organization, slug: 'organization-2', name: 'Organization 2')
    create(:organization, slug: 'organization-3', name: 'Organization 3')

    result = execute_graphql(
      mutation,
      variables: { organizationSlugs: ['organization-2', 'organization-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectOrganizations']['project']).to(eq(nil))
      expect(result['data']['updateProjectOrganizations']['errors'])
        .to(eq(['Editing project is not allowed.']))
    end
  end
end
