# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateCategoryIndicator, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateCategoryIndicator (
        $name: String!
        $slug: String!
        $indicatorType: String!
        $weight: Float!
        $rubricCategorySlug: String!
        $dataSource: String!
        $scriptName: String!
        $description: String!
        ) {
        createCategoryIndicator(
          name: $name
          slug:  $slug
          indicatorType:  $indicatorType
          weight:  $weight
          rubricCategorySlug: $rubricCategorySlug
          dataSource:  $dataSource
          scriptName:  $scriptName
          description:  $description
        ) {
            categoryIndicator
            {
              name
              slug
              indicatorType
              weight
              rubricCategoryId
              dataSource
              scriptName
              categoryIndicatorDescription{
              	description
              }
            }
            errors
          }
        }
    GQL
  end

  it 'creates category indicator - user is logged in as admin' do
    create(:rubric_category, slug: 'test_category', name: 'Test Category')
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        "name": "Test Name",
        "slug": "",
        "indicatorType": "scale",
        "weight": 0.2,
        "rubricCategorySlug": "test_category",
        "dataSource": "Digital Square",
        "scriptName": "name.sh",
        "description": "some description"
      }
    )

    aggregate_failures do
      expect(result['data']['createCategoryIndicator']['categoryIndicator'])
        .to(eq({
          "name" => "Test Name",
          "slug" => "test-name",
          "indicatorType" => "scale",
          "weight" => 0.2,
          "rubricCategoryId" => RubricCategory.find_by_slug("test_category").id,
          "dataSource" => "Digital Square",
          "scriptName" => "name.sh",
          "categoryIndicatorDescription" => { "description" => "some description" }
        }))
      expect(result['data']['createCategoryIndicator']['errors'])
        .to(eq([]))
    end
  end

  it 'updates a name without changing slug' do
    create(:rubric_category, slug: 'test_category', name: 'Test Category')
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        "name": "Test Name",
        "slug": "",
        "indicatorType": "scale",
        "weight": 0.2,
        "rubricCategorySlug": "test_category",
        "dataSource": "Digital Square",
        "scriptName": "name.sh",
        "description": "some description"
      }
    )

    aggregate_failures do
      expect(result['data']['createCategoryIndicator']['categoryIndicator'])
        .to(eq({
          "name" => "Test Name",
          "slug" => "test-name",
          "indicatorType" => "scale",
          "weight" => 0.2,
          "rubricCategoryId" => RubricCategory.find_by_slug("test_category").id,
          "dataSource" => "Digital Square",
          "scriptName" => "name.sh",
          "categoryIndicatorDescription" => { "description" => "some description" }
        }))
      expect(result['data']['createCategoryIndicator']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user has not proper rights' do
    create(:rubric_category, slug: 'test_category', name: 'Test Category')
    user = create(:user, email: 'user@gmail.com')

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        "name": "Test Name",
        "slug": "",
        "indicatorType": "scale",
        "weight": 0.2,
        "rubricCategorySlug": "test_category",
        "dataSource": "Digital Square",
        "scriptName": "name.sh",
        "description": "some description"
      }
    )

    aggregate_failures do
      expect(result['data']['createCategoryIndicator']['categoryIndicator'])
        .to(be(nil))
      expect(result['data']['createCategoryIndicator']['errors'])
        .to(eq(['Must be admin to create a category indicator.']))
    end
  end

  it 'fails - user is not logged in' do
    create(:rubric_category, slug: 'test_category', name: 'Test Category')
    user = create(:user, email: 'user@gmail.com')

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        "name": "Test Name",
        "slug": "",
        "indicatorType": "scale",
        "weight": 0.2,
        "rubricCategorySlug": "test_category",
        "dataSource": "Digital Square",
        "scriptName": "name.sh",
        "description": "some description"
      }
    )

    aggregate_failures do
      expect(result['data']['createCategoryIndicator']['categoryIndicator'])
        .to(be(nil))
      expect(result['data']['createCategoryIndicator']['errors'])
        .to(eq(['Must be admin to create a category indicator.']))
    end
  end
end
