# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::ProductsQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query SearchProducts (
        $first: Int,
        $after: String,
        $origins: [String!],
        $sectors: [String!],
        $countries: [String!],
        $organizations: [String!],
        $sdgs: [String!],
        $tags: [String!],
        $useCases: [String!],
        $workflows: [String!],
        $buildingBlocks: [String!],
        $productTypes: [String!],
        $endorsers: [String!],
        $productDeployable: Boolean,
        $withMaturity: Boolean,
        $licenseTypes: [String!],
        $search: String!
      ) {
        searchProducts (
          first: $first,
          after: $after,
          origins: $origins,
          sectors: $sectors,
          countries: $countries,
          organizations: $organizations,
          sdgs: $sdgs,
          tags: $tags,
          useCases: $useCases,
          workflows: $workflows,
          buildingBlocks: $buildingBlocks,
          productTypes: $productTypes,
          endorsers: $endorsers,
          productDeployable: $productDeployable,
          withMaturity: $withMaturity,
          licenseTypes: $licenseTypes,
          search: $search
        ) {
          __typename
          totalCount
          pageInfo {
            endCursor
            startCursor
            hasPreviousPage
            hasNextPage
          }
          nodes {
            id
            name
            slug
            imageFile
            isLaunchable
            maturityScore
            productType
            tags
            commercialProduct
            endorsers {
              name
              slug
            }
            origins{
              name
              slug
            }
            buildingBlocks {
              slug
              name
              imageFile
            }
            sustainableDevelopmentGoals {
              slug
              name
              imageFile
            }
            productDescriptions {
              description
              locale
            }
            organizations {
              name
              isEndorser
            }
          }
        }
      }
    GQL
  end

  it 'is successful' do
    create(:product, name: 'Open Something Source', website: 'http://something.com')

    result = execute_graphql(
      query,
      variables: { search: 'Open' }
    )

    aggregate_failures do
      expect(result['data']['searchProducts']['totalCount']).to(eq(1))
      expect(result['data']['searchProducts']['nodes'].count).to(eq(1))
    end
  end

  it 'fails' do
    result = execute_graphql(
      query,
      variables: { search: 'Whatever' }
    )

    expect(result['data']['searchProducts']['totalCount']).to(eq(0))
  end

  it 'filter and return only commercial products when flag is true.' do
    create(:product, name: 'Commercial Product', commercial_product: true)
    create(:product, name: 'Non Commercial Product', commercial_product: false)

    result = execute_graphql(
      query,
      variables: { search: '' }
    )

    expect(result['data']['searchProducts']['totalCount']).to(eq(2))

    result = execute_graphql(
      query,
      variables: { search: '', licenseTypes: ['commercial_only'] }
    )

    # Return only commercial products when flag is true.
    expect(result['data']['searchProducts']['totalCount']).to(eq(1))
    expect(result['data']['searchProducts']['nodes'][0]['name']).to(eq('Commercial Product'))
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

RSpec.describe(Queries::Product, type: :graphql) do
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
    create(:product, name: 'Some Product', slug: 'some_product', id: 1000)

    create(:rubric_category, name: 'Some RC', slug: 'some_rc', id: 1)

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
      variables: { slug: 'some_product' }
    )

    expect(result['data']['product']['notAssignedCategoryIndicators'])
      .not_to(include({ "indicatorType" => "scale", "name" => "Category Indicator 1" }))

    expect(result['data']['product']['productIndicators'])
      .to(eq([{ "categoryIndicator" => { "indicatorType" => "scale", "name" => "Category Indicator 1" },
                "indicatorValue" => "medium" }]))
  end
end
