# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProductExtraAttributes, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProductExtraAttributes (
        $slug: String!
        $localOwnership: String
        $impact: String
        $yearsInProduction: String
        ) {
          updateProductExtraAttributes (
            slug: $slug
            localOwnership: $localOwnership
            impact: $impact
            yearsInProduction: $yearsInProduction
          ) {
            product {
              slug
              extraAttributes
            }
            errors
            message
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:product, name: 'Test Product', slug: 'test-product', extra_attributes: {})
    expect_any_instance_of(Mutations::UpdateProductExtraAttributes).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
          variables: {
          slug: 'test-product',
          localOwnership: 'New Ownership',
          impact: 'High Impact',
          yearsInProduction: '10'
      },
    )

    aggregate_failures do
      expect(result['data']['updateProductExtraAttributes']['product']['extraAttributes'])
        .to(eq({
            "local_ownership" => "New Ownership",
            "impact" => "High Impact",
            "years_in_production" => "10"
        }))
      expect(result['data']['updateProductExtraAttributes']['errors'])
        .to(eq([]))
      expect(result['data']['updateProductExtraAttributes']['message'])
        .to(eq('Product extra attributes updated successfully'))
    end
  end

  it 'fails - user is not an admin or product owner' do
    create(:product, name: 'Test Product', slug: 'test-product', extra_attributes: {})

    result = execute_graphql(
      mutation,
          variables: {
          slug: 'test-product',
          localOwnership: 'New Ownership',
          impact: 'High Impact',
          yearsInProduction: '10'
      },
    )

    aggregate_failures do
      expect(result['data']['updateProductExtraAttributes']['product'])
        .to(eq(nil))
      expect(result['data']['updateProductExtraAttributes']['errors'])
        .to(eq(['Must be admin or product owner to update product attributes.']))
      expect(result['data']['updateProductExtraAttributes']['message'])
        .to(eq(nil))
    end
  end

  it 'is successful - updates only one field' do
    create(:product, name: 'Test Product', slug: 'test-product', extra_attributes: { "local_ownership" => "Old Ownership" })
    expect_any_instance_of(Mutations::UpdateProductExtraAttributes).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { slug: 'test-product', impact: 'Updated Impact' },
    )

    aggregate_failures do
      expect(result['data']['updateProductExtraAttributes']['product']['extraAttributes'])
        .to(eq({
            "local_ownership" => "Old Ownership",
            "impact" => "Updated Impact"
        }))
      expect(result['data']['updateProductExtraAttributes']['errors'])
        .to(eq([]))
      expect(result['data']['updateProductExtraAttributes']['message'])
        .to(eq('Product extra attributes updated successfully'))
    end
  end

  it 'fails - product not found' do
    expect_any_instance_of(Mutations::UpdateProductExtraAttributes).to(receive(:an_admin).and_return(true))
    result = execute_graphql(
      mutation,
      variables: {
          slug: 'non-existent-product',
          localOwnership: 'New Ownership',
          impact: 'High Impact',
          yearsInProduction: '10'
      },
    )

    aggregate_failures do
      expect(result['data']['updateProductExtraAttributes']['product'])
        .to(eq(nil))
      expect(result['data']['updateProductExtraAttributes']['errors'])
        .to(eq(['Product not found.']))
      expect(result['data']['updateProductExtraAttributes']['message'])
        .to(eq(nil))
    end
  end
end
