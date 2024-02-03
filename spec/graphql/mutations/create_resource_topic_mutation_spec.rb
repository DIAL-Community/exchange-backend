# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateResourceTopic, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateResourceTopic(
        $name: String!,
        $slug: String!,
        $description: String!
      ) {
        createResourceTopic(
          name: $name,
          slug: $slug,
          description: $description
        ) {
            resourceTopic {
              name
              slug
            }
            errors
          }
        }
    GQL
  end

  let(:query) do
    <<~GQL
      query Resource($slug: String!) {
        resource(slug: $slug) {
          slug
          name
          resourceTopics
        }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    admin = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])
    result = execute_graphql_as_user(
      admin,
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        description: 'Some description'
      }
    )

    aggregate_failures do
      expect(result['data']['createResourceTopic']['resourceTopic'])
        .to(eq({ "name" => "Some name", "slug" => "some-name" }))
    end
  end

  it 'is successful - admin can update resource topic name and slug remains the same' do
    create(:resource_topic, name: "Some name", slug: "some-name")
    admin = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin,
      mutation,
      variables: {
        name: "Some new name",
        slug: "some-name",
        description: 'Some description'
      }
    )

    aggregate_failures do
      expect(result['data']['createResourceTopic']['resourceTopic'])
        .to(eq({ "name" => "Some new name", "slug" => "some-name" }))
    end
  end

  it 'is successful - should update references on other objects' do
    create(:resource_topic, name: "Some Name", slug: "some-name")
    create(:resource, name: "Some Resource", slug: "some-resource", resource_topics: ['Some Name'])
    admin = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin,
      mutation,
      variables: {
        name: "Some New Name",
        slug: "some-name",
        description: 'Some description'
      }
    )

    # Get resource using the above resource topic and ensure the reference is updated.
    resource_result = execute_graphql(
      query,
      variables: {
        slug: 'some-resource'
      }
    )

    aggregate_failures do
      expect(result['data']['createResourceTopic']['resourceTopic'])
        .to(eq({ "name" => "Some New Name", "slug" => "some-name" }))
      # The resource topic update operation should also update resource topic list in the product object.
      expect(resource_result['data']['resource']['resourceTopics']).to(eq(['Some New Name']))
    end
  end

  # Preventing duplicate resource topic with the same name because name is used in other objects.
  it 'is successful - prevent resource topic with the same name to create duplicate' do
    graph_variables = {
      name: "Some Name",
      slug: "",
      description: 'Some description'
    }

    admin = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin,
      mutation,
      variables: graph_variables,
    )

    # First resource topic creation should use normal slug.
    aggregate_failures do
      expect(result['data']['createResourceTopic']['resourceTopic'])
        .to(eq({ "name" => "Some Name", "slug" => "some-name" }))
    end

    result = execute_graphql_as_user(
      admin,
      mutation,
      variables: graph_variables,
    )

    # The following create should add -duplicate-X to the slug when creating using the same name.
    aggregate_failures do
      expect(result['data']['createResourceTopic']['resourceTopic'])
        .to(eq({ "name" => "Some Name", "slug" => "some-name" }))
    end

    result = execute_graphql_as_user(
      admin,
      mutation,
      variables: graph_variables,
    )

    aggregate_failures do
      expect(result['data']['createResourceTopic']['resourceTopic'])
        .to(eq({ "name" => "Some Name", "slug" => "some-name" }))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        description: 'Some description'
      }
    )

    aggregate_failures do
      expect(result['data']['createResourceTopic']['resourceTopic'])
        .to(be(nil))
    end
  end
end
