# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateUseCaseStepProducts, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateUseCaseStepProducts (
        $productSlugs: [String!]!
        $slug: String!
        ) {
          updateUseCaseStepProducts (
            productSlugs: $productSlugs
            slug: $slug
          ) {
            useCaseStep {
              slug
              products {
                slug
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(
      :use_case_step,
      name: 'Some Name',
      slug: 'some-name',
      products: [create(:product, slug: 'product-1', name: 'Product 1')]
    )
    create(:product, slug: 'product-2', name: 'Product 2')
    create(:product, slug: 'product-3', name: 'Product 3')

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { productSlugs: ['product-2', 'product-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepProducts']['useCaseStep'])
        .to(eq({ "slug" => "some-name", "products" => [{ "slug" => "product-2" }, { "slug" => "product-3" }] }))
      expect(result['data']['updateUseCaseStepProducts']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    create(
      :use_case_step,
      name: 'Some Name',
      slug: 'some-name',
      products: [create(:product, slug: 'product-1', name: 'Product 1')]
    )
    create(:product, slug: 'product-2', name: 'Product 2')
    create(:product, slug: 'product-3', name: 'Product 3')

    editor_user = create(:user, email: 'user@gmail.com', roles: ['content_editor'])

    result = execute_graphql_as_user(
      editor_user,
      mutation,
      variables: { productSlugs: ['product-2', 'product-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepProducts']['useCaseStep'])
        .to(eq({ "slug" => "some-name", "products" => [{ "slug" => "product-2" }, { "slug" => "product-3" }] }))
      expect(result['data']['updateUseCaseStepProducts']['errors']).to(eq([]))
    end
  end

  it 'is fails - user has not proper rights' do
    create(
      :use_case_step,
      name: 'Some Name',
      slug: 'some-name',
      products: [create(:product, slug: 'product-1', name: 'Product 1')]
    )
    create(:product, slug: 'product-2', name: 'Product 2')
    create(:product, slug: 'product-3', name: 'Product 3')

    result = execute_graphql(
      mutation,
      variables: { productSlugs: ['product-2', 'product-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepProducts']['useCaseStep']).to(eq(nil))
      expect(result['data']['updateUseCaseStepProducts']['errors'])
        .to(eq(['Editing use case step is not allowed.']))
    end
  end

  it 'is fails - user is not logged in' do
    create(
      :use_case_step,
      name: 'Some Name',
      slug: 'some-name',
      products: [create(:product, slug: 'product-1', name: 'Product 1')]
    )
    create(:product, slug: 'product-2', name: 'Product 2')
    create(:product, slug: 'product-3', name: 'Product 3')

    result = execute_graphql(
      mutation,
      variables: { productSlugs: ['product-2', 'product-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepProducts']['useCaseStep']).to(eq(nil))
      expect(result['data']['updateUseCaseStepProducts']['errors'])
        .to(eq(['Editing use case step is not allowed.']))
    end
  end
end
