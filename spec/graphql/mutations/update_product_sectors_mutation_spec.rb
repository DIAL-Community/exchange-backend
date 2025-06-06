# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProductSectors, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProductSectors (
        $sectorSlugs: [String!]!
        $slug: String!
        ) {
          updateProductSectors (
            sectorSlugs: $sectorSlugs
            slug: $slug
          ) {
            product {
              slug
              sectors {
                slug
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:product, name: 'Some Name', slug: 'some-name', sectors: [create(:sector, slug: 'sec_1', name: 'Sec 1')])
    create(:sector, slug: 'sec_2', name: 'Sec 2')
    create(:sector, slug: 'sec_3', name: 'Sec 3')

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { sectorSlugs: ['sec_2', 'sec_3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProductSectors']['product'])
        .to(eq({ "slug" => "some-name", "sectors" => [{ "slug" => "sec_2" }, { "slug" => "sec_3" }] }))
      expect(result['data']['updateProductSectors']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:product, name: 'Some Name', slug: 'some-name', sectors: [create(:sector, slug: 'sec_1', name: 'Sec 1')])
    create(:sector, slug: 'sec_2', name: 'Sec 2')
    create(:sector, slug: 'sec_3', name: 'Sec 3')

    result = execute_graphql(
      mutation,
      variables: { sectorSlugs: ['sec_2', 'sec_3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProductSectors']['product'])
        .to(eq(nil))
      expect(result['data']['updateProductSectors']['errors'])
        .to(eq(['Editing product is not allowed.']))
    end
  end
end
