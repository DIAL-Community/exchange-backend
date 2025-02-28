# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProductSdgs, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProductSdgs (
        $sdgSlugs: [String!]!
        $slug: String!
        $mappingStatus: String!
        ) {
          updateProductSdgs (
            sdgSlugs: $sdgSlugs
            slug: $slug
            mappingStatus: $mappingStatus
          ) {
            product {
              slug
              sustainableDevelopmentGoals {
                slug
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:product, name: 'Some Name', slug: 'some-name',
                      sustainable_development_goals: [])
    create(:sustainable_development_goal, slug: 'sdg_2', name: 'SDG 2')
    create(:sustainable_development_goal, slug: 'sdg_3', name: 'SDG 3')

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { sdgSlugs: ['sdg_2', 'sdg_3'], slug: 'some-name', mappingStatus: 'VALIDATED' },
    )

    aggregate_failures do
      expect(result['data']['updateProductSdgs']['product'])
        .to(eq({ "slug" => "some-name",
                 "sustainableDevelopmentGoals" => [{ "slug" => "sdg_2" }, { "slug" => "sdg_3" }] }))
      expect(result['data']['updateProductSdgs']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:product, name: 'Some Name', slug: 'some-name',
                      sustainable_development_goals: [])
    create(:sustainable_development_goal, slug: 'sdg_2', name: 'SDG 2')
    create(:sustainable_development_goal, slug: 'sdg_3', name: 'SDG 3')

    result = execute_graphql(
      mutation,
      variables: { sdgSlugs: ['sdg_2', 'sdg_3'], slug: 'some-name', mappingStatus: 'VALIDATED' },
    )

    aggregate_failures do
      expect(result['data']['updateProductSdgs']['product']).to(eq(nil))
      expect(result['data']['updateProductSdgs']['errors'])
        .to(eq(['Editing product is not allowed.']))
    end
  end
end
