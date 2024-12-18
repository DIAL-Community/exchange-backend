# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateRubricCategory, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateRubricCategory (
        $name: String!
        $slug: String!
        $weight: Float!
        $description: String!
        ) {
        createRubricCategory(
          name: $name
          slug: $slug
          weight: $weight
          description: $description
        ) {
            rubricCategory
            {
              name
              slug
              weight
              rubricCategoryDescription {
                description
              }
            }
            errors
          }
        }
    GQL
  end

  it 'creates rubric category - user is logged in as admin' do
    admin_user = create(:user, email: 'admin@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { name: "Some name", slug: "", weight: 0.75, description: "some description" }
    )

    aggregate_failures do
      expect(result['data']['createRubricCategory']['rubricCategory'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name", "weight" => 0.75,
          "rubricCategoryDescription" => { "description" => "some description" }
        }))
      expect(result['data']['createRubricCategory']['errors'])
        .to(eq([]))
    end
  end

  it 'updates a name without changing slug' do
    admin_user = create(:user, email: 'admin@gmail.com', roles: ['admin'])
    create(:rubric_category, name: "Some name", slug: "some-name")

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { name: "Some new name", slug: "some-name", weight: 0.6, description: "some description" }
    )

    aggregate_failures do
      expect(result['data']['createRubricCategory']['rubricCategory'])
        .to(eq({
          "name" => "Some new name",
          "slug" => "some-name", "weight" => 0.6,
          "rubricCategoryDescription" => { "description" => "some description" }
        }))
      expect(result['data']['createRubricCategory']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user has not proper rights' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", weight: 0.75, description: "some description" }
    )

    aggregate_failures do
      expect(result['data']['createRubricCategory']['rubricCategory'])
        .to(be(nil))
      expect(result['data']['createRubricCategory']['errors'])
        .to(eq(['Creating / editing rubric category is not allowed.']))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", weight: 0.75, description: "some description" }
    )

    aggregate_failures do
      expect(result['data']['createRubricCategory']['rubricCategory'])
        .to(be(nil))
      expect(result['data']['createRubricCategory']['errors'])
        .to(eq(['Creating / editing rubric category is not allowed.']))
    end
  end
end
