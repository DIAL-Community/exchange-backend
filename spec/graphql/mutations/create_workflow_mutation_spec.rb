# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateWorkflow, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateWorkflow (
        $name: String!
        $slug: String!
        $description: String!
        ) {
        createWorkflow(
          name: $name
          slug: $slug
          description: $description
        ) {
            workflow
            {
              name
              slug
              workflowDescription {
                description
              }
            }
            errors
          }
        }
    GQL
  end

  it 'creates use case - user is logged in as admin' do
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { name: "Some name", slug: "", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createWorkflow']['workflow'])
        .to(eq({ "name" => "Some name", "slug" => "some-name",
                 "workflowDescription" => { "description" => "some description" } }))
      expect(result['data']['createWorkflow']['errors'])
        .to(eq([]))
    end
  end

  it 'creates use case - user is logged in as content editor' do
    content_editor_user = create(:user, email: 'content-editor-user@gmail.com', roles: ['content_editor'])
    result = execute_graphql_as_user(
      content_editor_user,
      mutation,
      variables: { name: "Some name", slug: "", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createWorkflow']['workflow'])
        .to(eq({ "name" => "Some name", "slug" => "some-name",
                 "workflowDescription" => { "description" => "some description" } }))
      expect(result['data']['createWorkflow']['errors'])
        .to(eq([]))
    end
  end

  it 'updates name for existing method matched by slug' do
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])
    create(:workflow, name: "Some name", slug: "some-name")

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { name: "Some new name", slug: "some-name", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createWorkflow']['workflow'])
        .to(eq({ "name" => "Some new name", "slug" => "some-name",
                 "workflowDescription" => { "description" => "some description" } }))
      expect(result['data']['createWorkflow']['errors'])
        .to(eq([]))
    end
  end

  it 'generate offset for new use case with duplicated name' do
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])
    create(:workflow, name: "Some name", slug: "some-name")

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { name: "Some name", slug: "", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createWorkflow']['workflow'])
        .to(eq({ "name" => "Some name", "slug" => "some-name-duplicate-0",
                 "workflowDescription" => { "description" => "some description" } }))
      expect(result['data']['createWorkflow']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user has not proper rights' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createWorkflow']['workflow'])
        .to(be(nil))
      expect(result['data']['createWorkflow']['errors'])
        .to(eq(['Creating / editing workflow is not allowed.']))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description" },
    )

    aggregate_failures do
      expect(result['data']['createWorkflow']['workflow'])
        .to(be(nil))
      expect(result['data']['createWorkflow']['errors'])
        .to(eq(['Creating / editing workflow is not allowed.']))
    end
  end
end
