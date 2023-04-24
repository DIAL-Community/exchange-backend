# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOrganizationProducts, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation($productSlugs: [String!]!, $slug: String!) {
        updateOrganizationProducts(
          productSlugs: $productSlugs
          slug: $slug
        ) {
          organization {
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

  it 'is successful' do
    first = create(:product, slug: 'first_product', name: 'First Product')
    second = create(:product, slug: 'second_product', name: 'Second Product')

    organization = create(:organization, name: 'Graph Organization', slug: 'graph_organization')
    expect_any_instance_of(Mutations::UpdateOrganizationProducts).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { productSlugs: [first.slug, second.slug], slug: organization.slug },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationProducts']['organization'])
        .to(eq({ "products" => [{ "slug" => first.slug }, { "slug" => second.slug }], "slug" => organization.slug }))
    end
  end
end
