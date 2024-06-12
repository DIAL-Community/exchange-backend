# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreatePlay, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreatePlay (
        $name: String!
        $slug: String!
        $owner: String!
        $description: String!
        $playbookSlug: String
        $productSlugs: [String!]
        $buildingBlockSlugs: [String!]
      ) {
        createPlay (
          name: $name
          slug: $slug
          owner: $owner
          description: $description
          playbookSlug: $playbookSlug
          productSlugs: $productSlugs
          buildingBlockSlugs: $buildingBlockSlugs
        ) {
          play {
            name
            slug
            playDescription{
              description
            }
            products {
              name
              slug
            }
            buildingBlocks {
              name
              slug
            }
          }
        }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    user = create(:user, email: 'user@gmail.com', roles: [:admin])

    create(:product, name: "Some Product", slug: "some-product")
    create(:building_block, name: "Some BB", slug: "some-bb")

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        owner: "Some Owner",
        description: "Some Description",
        productSlugs: ["some-product"],
        buildingBlockSlugs: ["some-bb"]
      }
    )

    aggregate_failures do
      expect(result['data']['createPlay']['play'])
        .to(eq(
          "name" => "Some name",
          "slug" => "some-name",
          "playDescription" => { "description" => "Some Description" },
          "products" => [{ "name" => "Some Product", "slug" => "some-product" }],
          "buildingBlocks" => [{ "name" => "Some BB", "slug" => "some-bb" }]
        ))
    end
  end

  it 'should assign play to playbook and not creating duplicate' do
    user = create(:user, email: 'user@gmail.com', roles: [:admin])

    create(:product, name: "Some Product", slug: "some-product")
    create(:building_block, name: "Some BB", slug: "some-bb")

    current_playbook = create(:playbook, id: 100, name: 'Some Playbook', slug: 'some-playbook', owned_by: 'Some Owner')
    expect(current_playbook.plays.length).to(eq(0))

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        owner: "Some Owner",
        description: "Some Description",
        playbookSlug: 'some-playbook',
        productSlugs: ["some-product"],
        buildingBlockSlugs: ["some-bb"]
      }
    )

    aggregate_failures do
      expect(result['data']['createPlay']['play']).to(
        eq(
          "name" => "Some name",
          "slug" => "some-name",
          "playDescription" => { "description" => "Some Description" },
          "products" => [{ "name" => "Some Product", "slug" => "some-product" }],
          "buildingBlocks" => [{ "name" => "Some BB", "slug" => "some-bb" }]
        )
      )
      current_playbook.reload
      expect(current_playbook.plays.length).to(eq(1))
    end

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        owner: "Some Owner",
        description: "Some Updated Description",
        playbookSlug: 'some-playbook',
        productSlugs: ["some-product"],
        buildingBlockSlugs: ["some-bb"]
      }
    )

    # Not creating duplicate assignment of play when updating a play object.
    aggregate_failures do
      expect(result['data']['createPlay']['play']).to(
        eq(
          "name" => "Some name",
          "slug" => "some-name",
          "playDescription" => { "description" => "Some Updated Description" },
          "products" => [{ "name" => "Some Product", "slug" => "some-product" }],
          "buildingBlocks" => [{ "name" => "Some BB", "slug" => "some-bb" }]
        )
      )
      current_playbook.reload
      expect(current_playbook.plays.length).to(eq(1))
    end
  end

  it 'is successful - user is logged in as content editor' do
    user = create(:user, email: 'user@gmail.com', roles: [:content_editor])

    create(:product, name: "Some Product", slug: "some-product")
    create(:building_block, name: "Some BB", slug: "some-bb")

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        owner: "Some Owner",
        description: "Some Description",
        productSlugs: ["some-product"],
        buildingBlockSlugs: ["some-bb"]
      },
    )

    aggregate_failures do
      expect(result['data']['createPlay']['play'])
        .to(eq(
          "name" => "Some name",
          "slug" => "some-name",
          "playDescription" => { "description" => "Some Description" },
          "products" => [{ "name" => "Some Product", "slug" => "some-product" }],
          "buildingBlocks" => [{ "name" => "Some BB", "slug" => "some-bb" }]
        ))
    end
  end

  it 'fails - user is not logged in' do
    create(:product, name: "Some Product", slug: "some-product")
    create(:building_block, name: "Some BB", slug: "some-bb")

    result = execute_graphql(
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        owner: "Some Owner",
        description: "Some Description",
        productSlugs: ["some-product"],
        buildingBlockSlugs: ["some-bb"]
      },
    )

    aggregate_failures do
      expect(result['data']['createPlay']['play'])
        .to(eq(nil))
    end
  end

  it 'fails - user has not proper rights' do
    expect_any_instance_of(Mutations::CreatePlay).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::CreatePlay).to(receive(:a_content_editor).and_return(false))

    create(:product, name: "Some Product", slug: "some-product")
    create(:building_block, name: "Some BB", slug: "some-bb")

    result = execute_graphql(
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        owner: "Some Owner",
        description: "Some Description",
        productSlugs: ["some-product"],
        buildingBlockSlugs: ["some-bb"]
      },
    )

    aggregate_failures do
      expect(result['data']['createPlay']['play'])
        .to(eq(nil))
    end
  end
end
