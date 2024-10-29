# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateUseCaseTags, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateUseCaseTags (
        $tagNames: [String!]!
        $slug: String!
        ) {
          updateUseCaseTags (
            tagNames: $tagNames
            slug: $slug
          ) {
            useCase {
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
    create(:use_case, name: 'Some Name', slug: 'some-name', tags: ['tag_1'])

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { tagNames: ['tag_2', 'tag_3'], slug: 'some-name' }
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseTags']['useCase'])
        .to(eq({ "slug" => "some-name", "tags" => ["tag_2", "tag_3"] }))
      expect(result['data']['updateUseCaseTags']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    create(:tag, name: 'tag_2')
    create(:tag, name: 'tag_3')
    create(:use_case, name: 'Some Name', slug: 'some-name', tags: ['tag_1'])

    editor_user = create(:user, email: 'editor-user@gmail.com', roles: ['content_editor'])

    result = execute_graphql_as_user(
      editor_user,
      mutation,
      variables: { tagNames: ['tag_2', 'tag_3'], slug: 'some-name' }
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseTags']['useCase'])
        .to(eq({ "slug" => "some-name", "tags" => ["tag_2", "tag_3"] }))
      expect(result['data']['updateUseCaseTags']['errors']).to(eq([]))
    end
  end

  it 'is fails - user has not proper rights' do
    create(:use_case, name: 'Some Name', slug: 'some-name', tags: ['tag_1'])

    result = execute_graphql(
      mutation,
      variables: { tagNames: ['tag_2', 'tag_3'], slug: 'some-name' }
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseTags']['useCase']).to(eq(nil))
      expect(result['data']['updateUseCaseTags']['errors'])
        .to(eq(['Editing use case is not allowed.']))
    end
  end

  it 'is fails - user is not logged in' do
    create(:use_case, name: 'Some Name', slug: 'some-name', tags: ['tag_1'])

    result = execute_graphql(
      mutation,
      variables: { tagNames: ['tag_2', 'tag_3'], slug: 'some-name' }
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseTags']['useCase']).to(eq(nil))
      expect(result['data']['updateUseCaseTags']['errors'])
        .to(eq(['Editing use case is not allowed.']))
    end
  end
end
