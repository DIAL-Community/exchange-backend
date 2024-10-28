# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::CategoryIndicatorQuery, type: :graphql) do
  let(:detail_query) do
    <<~GQL
      query CategoryIndicator ($slug: String!) {
        categoryIndicator (slug: $slug) {
          name
          slug
          weight
        }
      }
    GQL
  end

  let(:query) do
    <<~GQL
      query CategoryIndicators {
        categoryIndicators {
          name
          slug
          rubricCategoryId
        }
      }
    GQL
  end

  it 'pulls specific category indicator - user is logged as admin' do
    create(
      :rubric_category,
      name: 'Some Rubric Category',
      slug: 'some-rubric_category',
      weight: 0.75,
      id: 1
    )
    create(
      :category_indicator,
      name: 'Some Category Indicator',
      slug: 'some-category_indicator',
      weight: 0.75,
      rubric_category_id: 1
    )

    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      admin_user,
      detail_query,
      variables: { slug: 'some-category_indicator' },
      operation_context: VIEWING_CONTEXT
    )

    aggregate_failures do
      expect(result['data']['categoryIndicator'])
        .to(eq({
          "name" => "Some Category Indicator",
          "slug" => "some-category_indicator",
          "weight" => 0.75
        }))
    end
  end

  it 'pulls null rubric category - user is not logged as admin' do
    create(
      :rubric_category,
      name: 'Some Rubric Category',
      slug: 'some-rubric_category',
      weight: 0.75,
      id: 1
    )
    create(
      :category_indicator,
      name: 'Some Category Indicator',
      slug: 'some-category_indicator',
      weight: 0.75,
      rubric_category_id: 1
    )

    user = create(:user, email: 'user@gmail.com')

    result = execute_graphql_as_user(
      user,
      detail_query,
      variables: { slug: 'some-category_indicator' },
      operation_context: VIEWING_CONTEXT
    )

    aggregate_failures do
      expect(result['errors']).not_to(eq(nil))
    end
  end

  it 'pulls list of category indicators - user is logged as admin' do
    create(
      :category_indicator,
      name: 'Some Category Indicator',
      slug: 'some-category_indicator',
      weight: 0.75,
      rubric_category_id: nil
    )

    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      admin_user,
      query,
      operation_context: VIEWING_CONTEXT
    )

    aggregate_failures do
      expect(result['data']['categoryIndicators'])
        .to(eq([{
          "name" => "Some Category Indicator",
          "slug" => "some-category_indicator",
          "rubricCategoryId" => nil
        }]))
    end
  end

  it 'pulls null rubric categories - user is not logged as admin' do
    create(
      :category_indicator,
      name: 'Some Category Indicator',
      slug: 'some-category_indicator',
      weight: 0.75,
      rubric_category_id: nil
    )

    user = create(:user, email: 'user@gmail.com')

    result = execute_graphql_as_user(
      user,
      query,
      operation_context: VIEWING_CONTEXT
    )

    aggregate_failures do
      expect(result['errors']).not_to(eq(nil))
    end
  end
end
