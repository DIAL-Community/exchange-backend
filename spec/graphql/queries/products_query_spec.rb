# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::ProductsQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query Products($search: String) {
        products(search: $search) {
          id
          name
        }
      }
    GQL
  end

  it 'pulls products' do
    create(:product, slug: 'first_product', name: 'First Product', id: 1)
    create(:product, slug: 'second_product', name: 'Second Product', id: 2)

    result = execute_graphql(query)

    aggregate_failures do
      expect(result['data']['products'].count).to(eq(2))
    end
  end
end

RSpec.describe(Queries::OwnedProductsQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query {
        ownedProducts {
          id
          slug
          name
        }
      }
    GQL
  end

  let(:product_query) do
    <<~GQL
      query Product($slug: String!) {
        product(slug: $slug) {
          id
          slug
          name
          owner
        }
      }
    GQL
  end

  it 'pulls owned products for logged used' do
    first = create(:product, slug: 'first_product', name: 'First Product', id: 1)
    second = create(:product, slug: 'second_product', name: 'Second Product', id: 2)

    user = create(:user, email: 'user@gmail.com', user_products: [first.id, second.id])
    result = execute_graphql_as_user(user, query)

    aggregate_failures do
      expect(result['data']['ownedProducts'].count)
        .to(eq(2))
    end

    product_query_result = execute_graphql_as_user(user, product_query, variables: { slug: 'first_product' })
    aggregate_failures do
      expect(product_query_result['data']['product']['owner']).to(eq(user.id.to_s))
    end
  end

  it 'pulls empty array for not logged user' do
    result = execute_graphql(
      query
    )

    aggregate_failures do
      expect(result['data']['ownedProducts'].count)
        .to(eq(0))
    end
  end
end

RSpec.describe(Queries::ProductQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query Product($slug: String!) {
        product(slug: $slug) {
          productIndicators {
            indicatorValue
            categoryIndicator {
              name
              indicatorType
            }
          }
          notAssignedCategoryIndicators {
            name
            indicatorType
          }
        }
      }
    GQL
  end

  it 'pulls owned products for logged used' do
    create(:product, name: 'Some Product', slug: 'some-product', id: 1000)

    create(:rubric_category, name: 'Some RC', slug: 'some-rc', id: 1)

    category_indicator_1 = create(:category_indicator, name: 'Category Indicator 1',
                                                       slug: 'category_indicator_1',
                                                       indicator_type: 'scale',
                                                       rubric_category_id: 1)
    create(:category_indicator, name: 'Category Indicator 2',
                                slug: 'category_indicator_2',
                                indicator_type: 'boolean',
                                rubric_category_id: 1)

    create(:product_indicator, product_id: 1000,
                               category_indicator_id: category_indicator_1.id,
                               indicator_value: 'medium')

    result = execute_graphql(
      query,
      variables: { slug: 'some-product' }
    )

    expect(result['data']['product']['notAssignedCategoryIndicators'])
      .not_to(include({ "indicatorType" => "scale", "name" => "Category Indicator 1" }))

    expect(result['data']['product']['productIndicators'])
      .to(eq([{ "categoryIndicator" => { "indicatorType" => "scale", "name" => "Category Indicator 1" },
                "indicatorValue" => "medium" }]))
  end
end
