# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProductIndicators, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProductIndicators (
        $indicatorsData: [JSON!]!
        $slug: String!
        ) {
          updateProductIndicators (
            indicatorsData: $indicatorsData
            slug: $slug
          ) {
            product {
              productIndicators {
                indicatorValue
                categoryIndicator {
                  name
                }
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    product = create(:product, name: 'Some Name', slug: 'some_name')
    create(:rubric_category, name: 'RC', slug: 'rc', id: 1)
    ci_1 = create(:category_indicator, name: 'CI 1', slug: 'ci_1', rubric_category_id: 1)
    create(:category_indicator, name: 'CI 2', slug: 'ci_2', rubric_category_id: 1)
    create(:product_indicator, category_indicator_id: ci_1.id, product_id: product.id, indicator_value: 'high',
                               id: 1001)
    expect_any_instance_of(Mutations::UpdateProductIndicators).to(receive(:an_admin).and_return(true))

    indicators_data = [{ "category_indicator_slug" => "ci_1", "value" => "low" },
                       { "category_indicator_slug" => "ci_2", "value" => "t" }]

    result = execute_graphql(
      mutation,
      variables: { indicatorsData: indicators_data, slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProductIndicators']['product']['productIndicators'])
        .to(eq([{ "categoryIndicator" => { "name" => "CI 1" }, "indicatorValue" => "low" },
                { "categoryIndicator" => { "name" => "CI 2" }, "indicatorValue" => "t" }]))
      expect(result['data']['updateProductIndicators']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user has no proper rights' do
    product = create(:product, name: 'Some Name', slug: 'some_name')
    create(:rubric_category, name: 'RC', slug: 'rc', id: 1)
    ci_1 = create(:category_indicator, name: 'CI 1', slug: 'ci_1', rubric_category_id: 1)
    create(:category_indicator, name: 'CI 2', slug: 'ci_2', rubric_category_id: 1)
    create(:product_indicator, category_indicator_id: ci_1.id, product_id: product.id, indicator_value: 'high',
                               id: 1002)
    expect_any_instance_of(Mutations::UpdateProductIndicators).to(receive(:an_admin).and_return(false))

    indicators_data = [{ "category_indicator_slug" => "ci_1", "value" => "low" },
                       { "category_indicator_slug" => "ci_2", "value" => "t" }]

    result = execute_graphql(
      mutation,
      variables: { indicatorsData: indicators_data, slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateProductIndicators']['product'])
        .to(eq(nil))
      expect(result['data']['updateProductIndicators']['errors'])
        .to(eq(['Must be admin to update a product']))
    end
  end
end
