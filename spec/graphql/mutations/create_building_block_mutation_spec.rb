# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateBuildingBlock, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateBuildingBlock(
        $name: String!
        $slug: String!
        $description: String!
        $maturity: String!
        $category: String
        $specUrl: String
        $govStackEntity: Boolean
      ) {
        createBuildingBlock(
          name: $name
          slug: $slug
          description: $description
          maturity: $maturity
          category: $category
          specUrl: $specUrl
          govStackEntity: $govStackEntity
        ) {
            buildingBlock {
              name
              slug
              buildingBlockDescription {
                description
              }
              specUrl
              maturity
              category
              govStackEntity
            }
            errors
          }
        }
    GQL
  end

  it 'creates building block - user is logged in as admin' do
    admin_user = create(:user, email: 'admin@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some name",
        slug: "",
        description: "some description",
        maturity: "PUBLISHED",
        category: "DPI",
        specUrl: "some.url",
        govStackEntity: true
      }
    )

    aggregate_failures do
      expect(result['data']['createBuildingBlock']['buildingBlock'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name",
          "buildingBlockDescription" => { "description" => "some description" },
          "maturity" => "PUBLISHED",
          "category" => "DPI",
          "specUrl" => "some.url",
          "govStackEntity" => true
        }))
      expect(result['data']['createBuildingBlock']['errors']).to(eq([]))
    end
  end

  it 'creates building block - user is logged in as content editor' do
    content_editor_user = create(:user, email: 'editor@gmail.com', roles: [:content_editor])

    result = execute_graphql_as_user(
      content_editor_user,
      mutation,
      variables: {
        name: "Some name",
        slug: "",
        description: "some description",
        maturity: "BETA",
        category: nil,
        specUrl: "some.url",
        govStackEntity: true
      }
    )

    aggregate_failures do
      expect(result['data']['createBuildingBlock']['buildingBlock'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name",
          "buildingBlockDescription" => { "description" => "some description" },
          "maturity" => "BETA",
          "category" => nil,
          "specUrl" => "some.url",
          "govStackEntity" => false
        }))
      expect(result['data']['createBuildingBlock']['errors']).to(eq([]))
    end
  end

  it 'updates name for existing method matched by slug' do
    admin_user = create(:user, email: 'admin@gmail.com', roles: [:admin])
    create(:building_block, name: "Some name", slug: "some-name")

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some new name",
        slug: "some-name",
        description: "some description",
        maturity: "BETA",
        category: nil,
        specUrl: "some.url",
        govStackEntity: true
      }
    )

    aggregate_failures do
      expect(result['data']['createBuildingBlock']['buildingBlock'])
        .to(eq({
          "name" => "Some new name",
          "slug" => "some-name",
          "buildingBlockDescription" => { "description" => "some description" },
          "maturity" => "BETA",
          "category" => nil,
          "specUrl" => "some.url",
          "govStackEntity" => true
        }))
      expect(result['data']['createBuildingBlock']['errors']).to(eq([]))
    end
  end

  it 'generate offset for new building block with duplicated name' do
    admin_user = create(:user, email: 'admin@gmail.com', roles: [:admin])
    create(:building_block, name: "Some name", slug: "some-name")

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some name",
        slug: "",
        description: "some description",
        maturity: "BETA",
        category: nil,
        specUrl: "some.url"
      }
    )

    aggregate_failures do
      expect(result['data']['createBuildingBlock']['buildingBlock'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name-duplicate-0",
          "buildingBlockDescription" => { "description" => "some description" },
          "maturity" => "BETA",
          "category" => nil,
          "specUrl" => "some.url",
          "govStackEntity" => false
        }))
      expect(result['data']['createBuildingBlock']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user has not proper rights' do
    standard_user = create(:user, email: 'user@gmail.com', roles: [:user])

    result = execute_graphql_as_user(
      standard_user,
      mutation,
      variables: {
        name: "Some name",
        slug: "",
        description: "some description",
        maturity: "BETA",
        category: nil,
        specUrl: "some.url"
      }
    )

    aggregate_failures do
      expect(result['data']['createBuildingBlock']['buildingBlock'])
        .to(be(nil))
      expect(result['data']['createBuildingBlock']['errors'])
        .to(eq(['Must be admin or content editor to create building block']))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: {
        name: "Some name",
        slug: "",
        description: "some description",
        maturity: "BETA",
        category: nil,
        specUrl: "some.url"
      }
    )

    aggregate_failures do
      expect(result['data']['createBuildingBlock']['buildingBlock'])
        .to(be(nil))
      expect(result['data']['createBuildingBlock']['errors'])
        .to(eq(['Must be admin or content editor to create building block']))
    end
  end
end
