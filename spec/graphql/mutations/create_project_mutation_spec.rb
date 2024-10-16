# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateProject, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateProject (
        $name: String!
        $slug: String!
        $description: String!
        $countrySlugs: [String!]!
      ) {
        createProject(
          name: $name
          slug: $slug
          description: $description
          productId: null
          organizationId: null
          countrySlugs: $countrySlugs
        ) {
            project {
              name
              slug
              projectDescription {
                description
              }
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
    expect_any_instance_of(Mutations::CreateProject).to(receive(:an_admin).and_return(true))
    create(:origin, slug: 'manually-entered')
    create(:country, slug: 'usa')
    create(:country, slug: 'canada')

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description", countrySlugs: ["usa", "canada"] }
    )

    aggregate_failures do
      expect(result['data']['createProject']['project'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name",
          "projectDescription" => { "description" => "some description" },
          "countries" => [
            { "slug" => "usa" },
            { "slug" => "canada" }
          ]
        }))
      expect(result['data']['createProject']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - admin can update project name and slug remains the same' do
    create(:project, name: "Some name", slug: "some-name")
    create(:origin, slug: 'manually-entered')
    create(:country, slug: 'usa')
    create(:country, slug: 'canada')
    expect_any_instance_of(Mutations::CreateProject).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { name: "Some new name", slug: "some-name", description: "some description", countrySlugs: ["usa"] }
    )

    aggregate_failures do
      expect(result['data']['createProject']['project'])
        .to(eq({
          "name" => "Some new name",
          "slug" => "some-name",
          "projectDescription" => { "description" => "some description" },
          "countries" => [
            { "slug" => "usa" }
          ]
        }))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some-name", description: "some description", countrySlugs: [] }
    )

    aggregate_failures do
      expect(result['data']['createProject']['project'])
        .to(be(nil))
      expect(result['data']['createProject']['errors'])
        .to(eq(['Must be admin, product owner or organization owner to create a project']))
    end
  end

  it 'is successful - handles non-existent country slugs gracefully' do
    expect_any_instance_of(Mutations::CreateProject).to(receive(:an_admin).and_return(true))
    create(:origin, slug: 'manually-entered')
    create(:country, slug: 'usa')

    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description", countrySlugs: ["usa", "nonexistent"] }
    )

    aggregate_failures do
      expect(result['data']['createProject']['project'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name",
          "projectDescription" => { "description" => "some description" },
          "countries" => [
            { "slug" => "usa" }
          ]
        }))
      expect(result['data']['createProject']['errors'])
        .to(eq([]))
    end
  end
end
