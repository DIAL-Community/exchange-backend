# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProductTags, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProductTags (
        $tagNames: [String!]!
        $slug: String!
        ) {
          updateProductTags (
            tagNames: $tagNames
            slug: $slug
          ) {
            product {
              slug
              tags
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:tag, name: 'tag_2')
    create(:tag, name: 'tag_3')
    create(:product, name: 'Some Name', slug: 'some-name', tags: ['tag_1'])

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { tagNames: ['tag_2', 'tag_3'], slug: 'some-name' }
    )

    aggregate_failures do
      expect(result['data']['updateProductTags']['product'])
        .to(eq({ "slug" => "some-name", "tags" => ["tag_2", "tag_3"] }))
      expect(result['data']['updateProductTags']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:product, name: 'Some Name', slug: 'some-name', tags: ['tag_1'])

    result = execute_graphql(
      mutation,
      variables: { tagNames: ['tag_2', 'tag_3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProductTags']['product'])
        .to(eq(nil))
      expect(result['data']['updateProductTags']['errors'])
        .to(eq(['Editing product is not allowed.']))
    end
  end
end
