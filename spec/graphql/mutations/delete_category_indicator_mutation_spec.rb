# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteCategoryIndicator, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteCategoryIndicator ($id: ID!) {
        deleteCategoryIndicator(id: $id) {
          categoryIndicator {
            id
          }
          errors
        }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:rubric_category, id: 1000, name: 'Some RC', slug: 'some-rc')
    create(:category_indicator, id: 1000, name: 'Some CI', slug: 'some-ci', rubric_category_id: 1000)
    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteCategoryIndicator']['categoryIndicator'])
        .to(eq({ "id" => "1000" }))
      expect(result['data']['deleteCategoryIndicator']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:rubric_category, id: 5, name: 'Some RC', slug: 'some-rc')
    create(:category_indicator, id: 1000, name: 'Some CI', slug: 'some-ci', rubric_category_id: 5)

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteCategoryIndicator']['categoryIndicator'])
        .to(be(nil))
      expect(result['data']['deleteCategoryIndicator']['errors'])
        .to(eq(['Deleting category indicator is not allowed.']))
    end
  end
end
