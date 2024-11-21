# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateUseCase, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateUseCase(
        $name: String!
        $slug: String!
        $sectorSlug: String!
        $maturity: String!
        $description: String!
        $govStackEntity: Boolean
      ) {
        createUseCase(
          name: $name
          slug: $slug
          sectorSlug: $sectorSlug
          maturity: $maturity
          description: $description
          govStackEntity: $govStackEntity
        ) {
            useCase {
              name
              slug
              sector {
                slug
              }
              maturity
              govStackEntity
              useCaseDescription {
                description
              }
            }
            errors
          }
        }
    GQL
  end

  it 'creates use case - user is logged in as admin' do
    admin_user = create(:user, email: 'admin@gmail.com', roles: [:admin])
    create(:sector, slug: 'sec_1', name: 'Sec 1')

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some name",
        slug: "",
        sectorSlug: "sec_1",
        maturity: "BETA",
        description: "some description",
        govStackEntity: true
      }
    )

    aggregate_failures do
      expect(result['data']['createUseCase']['useCase'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name",
          "sector" => { "slug" => "sec_1" },
          "maturity" => "BETA",
          "govStackEntity" => true,
          "useCaseDescription" => { "description" => "some description" }
        }))
      expect(result['data']['createUseCase']['errors'])
        .to(eq([]))
    end
  end

  it 'creates use case - user is logged in as content editor' do
    editor_user = create(:user, email: 'editor@gmail.com', roles: [:content_editor])
    create(:sector, slug: 'sec_1', name: 'Sec 1')

    result = execute_graphql_as_user(
      editor_user,
      mutation,
      variables: {
        name: "Some name",
        slug: "",
        sectorSlug: "sec_1",
        maturity: "BETA",
        description: "some description",
        govStackEntity: true
      }
    )

    aggregate_failures do
      expect(result['data']['createUseCase']['useCase'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name",
          "sector" => { "slug" => "sec_1" },
          "maturity" => "BETA",
          "govStackEntity" => false,
          "useCaseDescription" => { "description" => "some description" }
        }))
      expect(result['data']['createUseCase']['errors'])
        .to(eq([]))
    end
  end

  it 'updates a name without changing slug' do
    admin_user = create(:user, email: 'admin@gmail.com', roles: [:admin])
    create(:use_case, name: "Some name", slug: "some-name")
    create(:sector, slug: 'sec_1', name: 'Sec 1')

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some new name",
        slug: "some-name",
        sectorSlug: "sec_1",
        maturity: "BETA",
        description: "some description"
      }
    )

    aggregate_failures do
      expect(result['data']['createUseCase']['useCase'])
        .to(eq({
          "name" => "Some new name",
          "slug" => "some-name",
          "sector" => { "slug" => "sec_1" },
          "maturity" => "BETA",
          "govStackEntity" => false,
          "useCaseDescription" => { "description" => "some description" }
        }))
      expect(result['data']['createUseCase']['errors'])
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
        sectorSlug: "sec_1",
        maturity: "BETA",
        description: "some description"
      }
    )

    aggregate_failures do
      expect(result['data']['createUseCase']['useCase'])
        .to(be(nil))
      expect(result['data']['createUseCase']['errors'])
        .to(eq(['Creating / editing use case is not allowed.']))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: {
        name: "Some name",
        slug: "",
        sectorSlug: "sec_1",
        maturity: "BETA",
        description: "some description"
      }
    )

    aggregate_failures do
      expect(result['data']['createUseCase']['useCase'])
        .to(be(nil))
      expect(result['data']['createUseCase']['errors'])
        .to(eq(['Creating / editing use case is not allowed.']))
    end
  end
end
