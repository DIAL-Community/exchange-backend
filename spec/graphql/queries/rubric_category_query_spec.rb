# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::RubricCategoryQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query RubricCategories ($search: String) {
        rubricCategories (search: $search) {
          name
          slug
          weight
        }
      }
    GQL
  end

  let(:detail_query) do
    <<~GQL
      query RubricCategory ($slug: String!) {
        rubricCategory (slug: $slug) {
          name
          slug
          weight
        }
      }
    GQL
  end

  it 'pulls list of rubric categories - user is logged as admin' do
    create(:rubric_category, name: 'Some Rubric Category', slug: 'some-rubric_category', weight: 0.75)
    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])
    result = execute_graphql_as_user(
      admin_user,
      query,
      variables: { search: 'Some' }
    )

    aggregate_failures do
      expect(result['data']['rubricCategories'])
        .to(eq([{
          "name" => "Some Rubric Category",
          "slug" => "some-rubric_category",
          "weight" => 0.75
        }]))
    end
  end

  it 'pulls empty list - user is not logged as admin' do
    create(:rubric_category, name: 'Some Rubric Category', slug: 'some-rubric_category', weight: 0.75)
    user = create(:user, email: 'user@gmail.com')
    result = execute_graphql_as_user(
      user,
      query,
      variables: { search: 'Some' }
    )

    aggregate_failures do
      expect(result['errors']).not_to(eq(nil))
    end
  end

  it 'pulls specific rubric category - user is logged as admin' do
    create(:rubric_category, name: 'Some Rubric Category', slug: 'some-rubric_category', weight: 0.75)
    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])
    result = execute_graphql_as_user(
      admin_user,
      detail_query,
      variables: { slug: 'some-rubric_category' }
    )

    aggregate_failures do
      expect(result['data']['rubricCategory'])
        .to(eq({
          "name" => "Some Rubric Category",
          "slug" => "some-rubric_category",
          "weight" => 0.75
        }))
    end
  end

  it 'pulls null rubric category - user is not logged as admin' do
    create(:rubric_category, name: 'Some Rubric Category', slug: 'some-rubric_category', weight: 0.75)
    user = create(:user, email: 'user@gmail.com')
    result = execute_graphql_as_user(
      user,
      detail_query,
      variables: { slug: 'some-rubric_category' }
    )

    aggregate_failures do
      expect(result['errors']).not_to(eq(nil))
    end
  end
end
