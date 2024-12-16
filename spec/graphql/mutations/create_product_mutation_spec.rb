# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateProduct, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateProduct(
        $name: String!,
        $slug: String!,
        $description: String!,
        $govStackEntity: Boolean,
        $productStage: String,
        $extraAttributes: [ExtraAttribute!],
        $featured: Boolean,
        $contact: String
      ) {
        createProduct(
          name: $name,
          slug: $slug,
          aliases: {},
          website: "somewebsite.org",
          description: $description,
          govStackEntity: $govStackEntity,
          productStage: $productStage,
          extraAttributes: $extraAttributes,
          featured: $featured,
          contact: $contact
        ) {
          product {
            name
            slug
            govStackEntity
            productStage
            featured
            contact
            productDescription {
              description
            }
            extraAttributes
          }
          errors
        }
      }
    GQL
  end

  it 'is successful - user is logged in as admin with extra attributes' do
    admin_user = create(:user, email: 'admin@gmail.com', roles: [:admin])

    extra_attributes = [
      { "name" => "impact", "type" => "product_scale", "value" => "Very High" },
      { "name" => "local_ownership", "type" => "product_scale", "value" => "Local Authority" },
      { "name" => "years_in_production", "type" => "product_scale", "value" => 8 },
      { "name" => "deployments", "type" => "integer", "value" => 15 },
      { "name" => "deployment_countries", "type" => "integer", "value" => 10 },
      { "name" => "daily_users", "type" => "integer", "value" => 25000 },
      { "name" => "transactions_per_month", "type" => "integer", "value" => 100000 },
      { "name" => "annual_revenue", "type" => "integer", "value" => 5000000 },
      { "name" => "funding_raised", "type" => "product_scale", "value" => 20000000 }
    ]

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        description: "Some description",
        productStage: nil,
        extraAttributes: extra_attributes,
        featured: true,
        contact: "contact@example.com"
      }
    )

    aggregate_failures do
      expect(result['data']['createProduct']['product']).to(eq({
        "name" => "Some name",
        "govStackEntity" => false,
        "productDescription" => { "description" => "Some description" },
        "slug" => "some-name",
        "productStage" => nil,
        "featured" => true,
        "contact" => "contact@example.com",
        "extraAttributes" => extra_attributes.map(&:stringify_keys)
      }))
      expect(result['data']['createProduct']['errors']).to(eq([]))
    end
  end

  it 'fails - setting gov stack field as non-admin' do
    created_product = create(:product, name: 'Some Name', slug: 'some-name')
    owner_user = create(:user, email: 'owner@gmail.com', roles: [:product_owner], user_products: [created_product.id])

    extra_attributes = [
      { "name" => "impact", "type" => "product_scale", "value" => "Very High" },
      { "name" => "local_ownership", "type" => "product_scale", "value" => "Local Authority" }
    ]

    result = execute_graphql_as_user(
      owner_user,
      mutation,
      variables: {
        name: "Some other name",
        slug: "some-name",
        description: "Some description",
        govStackEntity: true,
        productStage: nil,
        extraAttributes: extra_attributes
      }
    )

    aggregate_failures do
      expect(result['data']['createProduct']['product']).to(eq({
        "name" => "Some other name",
        "govStackEntity" => false,
        "slug" => "some-name",
        "productStage" => nil,
        "productDescription" => { "description" => "Some description" },
        "extraAttributes" => extra_attributes.map(&:stringify_keys),
        "featured" => false,
        "contact" => nil
      }))
      expect(result['data']['createProduct']['errors']).to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    extra_attributes = [
      { "name" => "impact", "type" => "product_scale", "value" => "Very High" }
    ]

    result = execute_graphql(
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        description: "Some description",
        productStage: nil,
        extraAttributes: extra_attributes
      }
    )

    aggregate_failures do
      expect(result['data']['createProduct']['product']).to(be(nil))
      expect(result['data']['createProduct']['errors']).to(eq(['Creating / editing product is not allowed.']))
    end
  end
end
