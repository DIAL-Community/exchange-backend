# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProductExtraAttributes, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProductExtraAttributes (
        $slug: String!
        $extraAttributes: [ExtraAttribute!]!
      ) {
        updateProductExtraAttributes (
          slug: $slug
          extraAttributes: $extraAttributes
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

  it 'is successful - adds new fields related to product scale' do
    create(:product, name: 'Test Product', slug: 'test-product', extra_attributes: [])

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        slug: 'test-product',
        extraAttributes: [
          { name: "local_ownership", value: "New Ownership", type: "string" },
          { name: "impact", value: "High Impact", type: "string" },
          { name: "years_in_production", value: 10, type: "integer" },
          { name: "deployments", value: 5, type: "integer" },
          { name: "deployment_countries", value: 3, type: "integer" },
          { name: "daily_users", value: 1000, type: "integer" },
          { name: "transactions_per_month", value: 5000, type: "integer" },
          { name: "annual_revenue", value: 200000, type: "integer" },
          { name: "funding_raised", value: 1000000, type: "integer" }
        ]
      },
    )

    aggregate_failures do
      expect(result['data']['updateProductExtraAttributes']['product']['extraAttributes'])
        .to(eq([
          { "name" => "local_ownership", "value" => "New Ownership", "type" => "string" },
          { "name" => "impact", "value" => "High Impact", "type" => "string" },
          { "name" => "years_in_production", "value" => 10, "type" => "integer" },
          { "name" => "deployments", "value" => 5, "type" => "integer" },
          { "name" => "deployment_countries", "value" => 3, "type" => "integer" },
          { "name" => "daily_users", "value" => 1000, "type" => "integer" },
          { "name" => "transactions_per_month", "value" => 5000, "type" => "integer" },
          { "name" => "annual_revenue", "value" => 200000, "type" => "integer" },
          { "name" => "funding_raised", "value" => 1000000, "type" => "integer" }
        ]))
      expect(result['data']['updateProductExtraAttributes']['errors'])
        .to(eq([]))
      expect(result['data']['updateProductExtraAttributes']['message'])
        .to(eq('Product extra attributes updated successfully'))
    end
  end

  it 'is successful - user is logged in as admin' do
    create(:product, name: 'Test Product', slug: 'test-product', extra_attributes: [])

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        slug: 'test-product',
        extraAttributes: [
          { name: "local_ownership", value: "New Ownership", type: "string" },
          { name: "impact", value: "High Impact", type: "string" },
          { name: "years_in_production", value: "10", type: "integer" }
        ]
      },
    )
    aggregate_failures do
      expect(result['data']['updateProductExtraAttributes']['product']['extraAttributes'])
        .to(eq([
          { "name" => "local_ownership", "value" => "New Ownership", "type" => "string" },
          { "name" => "impact", "value" => "High Impact", "type" => "string" },
          { "name" => "years_in_production", "value" => "10", "type" => "integer" }
        ]))
      expect(result['data']['updateProductExtraAttributes']['errors']).to(eq([]))
      expect(result['data']['updateProductExtraAttributes']['message'])
        .to(eq('Product extra attributes updated successfully'))
    end
  end

  it 'fails - user is not an admin or product owner' do
    create(:product, name: 'Test Product', slug: 'test-product', extra_attributes: [])

    result = execute_graphql(
      mutation,
      variables: {
        slug: 'test-product',
        extraAttributes: [
          { name: "local_ownership", value: "New Ownership", type: "string" },
          { name: "impact", value: "High Impact", type: "string" },
          { name: "years_in_production", value: "10", type: "integer" }
        ]
      },
    )
    aggregate_failures do
      expect(result['data']['updateProductExtraAttributes']['product']).to(eq(nil))
      expect(result['data']['updateProductExtraAttributes']['errors'])
        .to(eq(['Editing product is not allowed.']))
      expect(result['data']['updateProductExtraAttributes']['message']).to(eq(nil))
    end
  end

  it 'is successful - updates only one field' do
    create(
      :product,
      name: 'Test Product',
      slug: 'test-product',
      extra_attributes: [{ "name" => "local_ownership", "value" => "Old Ownership", "type" => "string" }]
    )

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        slug: 'test-product',
        extraAttributes: [
          { name: "impact", value: "Updated Impact", type: "string" }
        ]
      },
    )
    aggregate_failures do
      expect(result['data']['updateProductExtraAttributes']['product']['extraAttributes'])
        .to(eq([
          { "name" => "local_ownership", "value" => "Old Ownership", "type" => "string" },
          { "name" => "impact", "value" => "Updated Impact", "type" => "string" }
        ]))
      expect(result['data']['updateProductExtraAttributes']['errors']).to(eq([]))
      expect(result['data']['updateProductExtraAttributes']['message'])
        .to(eq('Product extra attributes updated successfully'))
    end
  end

  it 'fails - product not found' do
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])
    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        slug: 'non-existent-product',
        extraAttributes: [
          { name: "local_ownership", value: "New Ownership", type: "string" },
          { name: "impact", value: "High Impact", type: "string" },
          { name: "years_in_production", value: "10", type: "integer" }
        ]
      },
    )
    aggregate_failures do
      expect(result['data']['updateProductExtraAttributes']['product']).to(eq(nil))
      expect(result['data']['updateProductExtraAttributes']['errors'])
        .to(eq(['Editing product is not allowed.']))
      expect(result['data']['updateProductExtraAttributes']['message']).to(eq(nil))
    end
  end
end
