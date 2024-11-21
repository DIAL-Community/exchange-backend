# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateUseCaseStep, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateUseCaseStep (
        $name: String!
        $slug: String!
        $description: String
        $stepNumber: Int!
        $useCaseId: Int!
        ) {
        createUseCaseStep(
          name: $name
          slug: $slug
          description: $description
          stepNumber: $stepNumber
          useCaseId: $useCaseId
        ) {
            useCaseStep
            {
              name
              slug
              useCaseStepDescription {
                description
              }
              stepNumber
              useCase {
                id
              }
            }
            errors
          }
        }
    GQL
  end

  it 'creates use case - user is logged in as admin' do
    create(:use_case, id: 3)
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some name",
        slug: "",
        description: "some description",
        stepNumber: 5,
        useCaseId: 3
      }
    )

    aggregate_failures do
      expect(result['data']['createUseCaseStep']['useCaseStep'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name",
          "useCaseStepDescription" => { "description" => "some description" },
          "stepNumber" => 5,
          "useCase" => { "id" => "3" }
        }))
      expect(result['data']['createUseCaseStep']['errors'])
        .to(eq([]))
    end
  end

  it 'creates use case - user is logged in as content editor' do
    create(:use_case, id: 3)
    content_editor_user = create(:user, email: 'content-editor-user@gmail.com', roles: ['content_editor'])

    result = execute_graphql_as_user(
      content_editor_user,
      mutation,
      variables: {
        name: "Some name",
        slug: "",
        description: "some description",
        stepNumber: 5,
        useCaseId: 3
      }
    )

    aggregate_failures do
      expect(result['data']['createUseCaseStep']['useCaseStep'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name",
          "useCaseStepDescription" => { "description" => "some description" },
          "stepNumber" => 5,
          "useCase" => { "id" => "3" }
        }))
      expect(result['data']['createUseCaseStep']['errors'])
        .to(eq([]))
    end
  end

  it 'creates use case - user is logged in as content editor' do
    create(:use_case, id: 3)
    content_editor_user = create(:user, email: 'content-editor-user@gmail.com', roles: ['content_editor'])

    result = execute_graphql_as_user(
      content_editor_user,
      mutation,
      variables: { name: "Some name", slug: "", stepNumber: 5, useCaseId: 3 },
    )

    aggregate_failures do
      expect(result['data']['createUseCaseStep']['useCaseStep'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name",
          "stepNumber" => 5,
          "useCase" => { "id" => "3" },
          "useCaseStepDescription" => nil
        }))
      expect(result['data']['createUseCaseStep']['errors'])
        .to(eq([]))
    end
  end

  it 'updates name for existing method matched by slug' do
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])
    create(:use_case, id: 3)
    create(:use_case_step, name: "Some name", slug: "some-name", step_number: 5)

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some new name",
        slug: "some-name",
        description: "some description",
        stepNumber: 5,
        useCaseId: 3
      }
    )

    aggregate_failures do
      expect(result['data']['createUseCaseStep']['useCaseStep'])
        .to(eq({
          "name" => "Some new name",
          "slug" => "some-name",
          "useCaseStepDescription" => { "description" => "some description" },
          "stepNumber" => 5,
          "useCase" => { "id" => "3" }
        }))
      expect(result['data']['createUseCaseStep']['errors'])
        .to(eq([]))
    end
  end

  it 'generate offset for new use case with duplicated name' do
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])
    create(:use_case, id: 5)
    create(:use_case_step, name: "Some name", slug: "some-name", step_number: 5)

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some name",
        slug: "",
        description: "some description",
        stepNumber: 5,
        useCaseId: 3
      }
    )

    aggregate_failures do
      expect(result['data']['createUseCaseStep']['useCaseStep'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name-duplicate-0",
          "useCaseStepDescription" => { "description" => "some description" },
          "stepNumber" => 5,
          "useCase" => { "id" => "3" }
        }))
      expect(result['data']['createUseCaseStep']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user has not proper rights' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description", stepNumber: 5, useCaseId: 3 }
    )

    aggregate_failures do
      expect(result['data']['createUseCaseStep']['useCaseStep'])
        .to(be(nil))
      expect(result['data']['createUseCaseStep']['errors'])
        .to(eq(['Creating / editing use case step is not allowed.']))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "", description: "some description", stepNumber: 5, useCaseId: 3 }
    )

    aggregate_failures do
      expect(result['data']['createUseCaseStep']['useCaseStep'])
        .to(be(nil))
      expect(result['data']['createUseCaseStep']['errors'])
        .to(eq(['Creating / editing use case step is not allowed.']))
    end
  end
end
