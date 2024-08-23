# frozen_string_literal: true
# spec/graphql/mutations/update_product_stage_mutation_spec.rb
require 'rails_helper'
require 'graph_helpers'

RSpec.describe(Mutations::UpdateProductStage, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProductStage(
        $productStage: String!
        $slug: String!
      ) {
        updateProductStage(
          productStage: $productStage
          slug: $slug
        ) {
          product {
            slug
            productStage
          }
          errors
          message
        }
      }
    GQL
  end

  let(:product) { create(:product, name: 'test-product', slug: 'test-product') }
  let(:non_admin_user) { create(:user) }

  context 'when mutation is called' do
    it 'successfully executes the mutation and returns a message' do
      expect_any_instance_of(Mutations::UpdateProductStage).to(receive(:an_admin).and_return(true))

      result = execute_graphql(
        mutation,
        variables: { productStage: 'pilot', slug: product.slug },
      )

      aggregate_failures do
        expect(result).not_to(be_nil)
        expect(result['data']).not_to(be_nil)
        expect(result['data']['updateProductStage']['product']['slug']).to(eq(product.slug))
        expect(result['data']['updateProductStage']['product']['productStage']).to(eq('pilot'))
        expect(result['data']['updateProductStage']['errors']).to(be_empty)
        expect(result['data']['updateProductStage']['message']).to(eq('Product stage updated successfully'))
      end
    end

    it 'returns an error when an invalid product stage is provided' do
      expect_any_instance_of(Mutations::UpdateProductStage).to(receive(:an_admin).and_return(true))

      result = execute_graphql(
        mutation,
        variables: { productStage: 'fsafasf', slug: product.slug },
      )

      aggregate_failures do
        expect(result).not_to(be_nil)
        expect(result['data']).not_to(be_nil)
        expect(result['data']['updateProductStage']['product']).to(be_nil)
        expect(result['data']['updateProductStage']['errors']).to(include('Invalid product stage'))
        expect(result['data']['updateProductStage']['message']).to(be_nil)
      end
    end

    it 'returns an error when the user is not an admin' do
      expect_any_instance_of(Mutations::UpdateProductStage).to(receive(:an_admin).and_return(false))

      result = execute_graphql(
        mutation,
        variables: { productStage: 'pilot', slug: product.slug },
      )

      aggregate_failures do
        expect(result).not_to(be_nil)
        expect(result['data']).not_to(be_nil)
        expect(result['data']['updateProductStage']['product']).to(be_nil)
        expect(result['data']['updateProductStage']['errors']).to(include('Must be admin to update a product stage.'))
        expect(result['data']['updateProductStage']['message']).to(be_nil)
      end
    end

    it 'returns an error when the product is not found' do
      expect_any_instance_of(Mutations::UpdateProductStage).to(receive(:an_admin).and_return(true))

      result = execute_graphql(
        mutation,
        variables: { productStage: 'production', slug: 'non-existent-slug' },
      )

      aggregate_failures do
        expect(result).not_to(be_nil)
        expect(result['data']).not_to(be_nil)
        expect(result['data']['updateProductStage']['product']).to(be_nil)
        expect(result['data']['updateProductStage']['errors']).to(include('Product not found.'))
        expect(result['data']['updateProductStage']['message']).to(be_nil)
      end
    end

    it 'returns an error when the user is not logged in' do
      result = execute_graphql(
        mutation,
        variables: { productStage: 'pilot', slug: product.slug },
        context: { current_user: nil }
      )

      aggregate_failures do
        expect(result).not_to(be_nil)
        expect(result['data']).not_to(be_nil)
        expect(result['data']['updateProductStage']['product']).to(be_nil)
        expect(result['data']['updateProductStage']['errors']).to(include('Must be admin to update a product stage.'))
        expect(result['data']['updateProductStage']['message']).to(be_nil)
      end
    end
  end
end
