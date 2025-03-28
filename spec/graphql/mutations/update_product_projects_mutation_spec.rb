# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProductProjects, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProductProjects (
        $projectSlugs: [String!]!
        $slug: String!
        ) {
          updateProductProjects (
            projectSlugs: $projectSlugs
            slug: $slug
          ) {
            product {
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

  it 'is successful - user is logged in as admin' do
    create(:product, name: 'Some Name', slug: 'some-name',
                     projects: [create(:project, slug: 'project_1', name: 'Project 1')])
    create(:project, slug: 'project_2', name: 'Project 2')
    create(:project, slug: 'project_3', name: 'Project 3')

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { projectSlugs: ['project_2', 'project_3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProductProjects']['product'])
        .to(eq({ "slug" => "some-name", "projects" => [{ "slug" => "project_2" }, { "slug" => "project_3" }] }))
      expect(result['data']['updateProductProjects']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:product, name: 'Some Name', slug: 'some-name',
                     projects: [create(:project, slug: 'project_1', name: 'Project 1')])
    create(:project, slug: 'project_2', name: 'Project 2')
    create(:project, slug: 'project_3', name: 'Project 3')

    result = execute_graphql(
      mutation,
      variables: { projectSlugs: ['project_2', 'project_3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProductProjects']['product']).to(eq(nil))
      expect(result['data']['updateProductProjects']['errors'])
        .to(eq(['Editing product is not allowed.']))
    end
  end
end
