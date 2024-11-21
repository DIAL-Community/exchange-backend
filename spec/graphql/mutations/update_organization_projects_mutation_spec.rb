# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOrganizationProjects, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation($projectSlugs: [String!]!, $slug: String!) {
        updateOrganizationProjects(
          projectSlugs: $projectSlugs
          slug: $slug
        ) {
          organization {
            slug
            projects {
              slug
            }
          }
          errors
        }
      }
    GQL
  end

  it 'is successful' do
    first = create(:project, slug: 'first_project', name: 'First Project')
    second = create(:project, slug: 'second_project', name: 'Second Project')

    organization = create(:organization, name: 'Graph Organization', slug: 'graph_organization')

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { projectSlugs: [first.slug, second.slug], slug: organization.slug },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationProjects']['organization'])
        .to(eq({ "projects" => [{ "slug" => first.slug }, { "slug" => second.slug }], "slug" => organization.slug }))
    end
  end
end
