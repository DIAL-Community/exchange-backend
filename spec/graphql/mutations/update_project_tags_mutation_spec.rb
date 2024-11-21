# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateProjectTags, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateProjectTags (
        $tagNames: [String!]!
        $slug: String!
        ) {
          updateProjectTags (
            tagNames: $tagNames
            slug: $slug
          ) {
            project {
              slug
              tags
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:tag, name: 'tag-2')
    create(:tag, name: 'tag-3')
    create(:project, name: 'Some Name', slug: 'some-name', tags: ['tag-1'])

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { tagNames: ['tag-2', 'tag-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectTags']['project'])
        .to(eq({ "slug" => "some-name", "tags" => ["tag-2", "tag-3"] }))
      expect(result['data']['updateProjectTags']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as product owner' do
    create(:tag, name: 'tag-2')
    create(:tag, name: 'tag-3')
    create(
      :project,
      name: 'Some Name',
      slug: 'some-name',
      tags: ['tag-1'],
      products: [create(:product, id: 10001)]
    )

    product_owner = create(
      :user,
      email: 'user@gmail.com',
      roles: ['product_owner'],
      user_products: [10001]
    )

    result = execute_graphql_as_user(
      product_owner,
      mutation,
      variables: { tagNames: ['tag-2', 'tag-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectTags']['project'])
        .to(eq({ "slug" => "some-name", "tags" => ["tag-2", "tag-3"] }))
      expect(result['data']['updateProjectTags']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as organization owner' do
    create(:tag, name: 'tag-2')
    create(:tag, name: 'tag-3')
    create(
      :project,
      name: 'Some Name',
      slug: 'some-name',
      organizations: [create(
        :organization,
        id: 10001,
        slug: 'organization-1',
        name: 'Organization 1',
        website: 'website.com'
      )],
      tags: ['tag-1']
    )

    organization_owner = create(
      :user,
      email: 'user@website.com',
      roles: ['organization_owner'],
      organization_id: 10001
    )

    result = execute_graphql_as_user(
      organization_owner,
      mutation,
      variables: { tagNames: ['tag-2', 'tag-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectTags']['project'])
        .to(eq({ "slug" => "some-name", "tags" => ["tag-2", "tag-3"] }))
      expect(result['data']['updateProjectTags']['errors']).to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:project, name: 'Some Name', slug: 'some-name', tags: ['tag-1'])

    result = execute_graphql(
      mutation,
      variables: { tagNames: ['tag-2', 'tag-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectTags']['project']).to(eq(nil))
      expect(result['data']['updateProjectTags']['errors'])
        .to(eq(['Editing project is not allowed.']))
    end
  end
end
