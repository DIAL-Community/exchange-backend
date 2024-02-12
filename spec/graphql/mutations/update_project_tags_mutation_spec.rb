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
    create(:tag, name: 'tag_2')
    create(:tag, name: 'tag_3')
    create(:project, name: 'Some Name', slug: 'some-name', tags: ['tag_1'])
    expect_any_instance_of(Mutations::UpdateProjectTags).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { tagNames: ['tag_2', 'tag_3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectTags']['project'])
        .to(eq({ "slug" => "some-name", "tags" => ["tag_2", "tag_3"] }))
      expect(result['data']['updateProjectTags']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as product owner' do
    create(:tag, name: 'tag_2')
    create(:tag, name: 'tag_3')
    create(:project, name: 'Some Name', slug: 'some-name', tags: ['tag_1'])
    expect_any_instance_of(Mutations::UpdateProjectTags).to(receive(:product_owner_check_for_project)
      .and_return(true))

    result = execute_graphql(
      mutation,
      variables: { tagNames: ['tag_2', 'tag_3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectTags']['project'])
        .to(eq({ "slug" => "some-name", "tags" => ["tag_2", "tag_3"] }))
      expect(result['data']['updateProjectTags']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as organization owner' do
    create(:tag, name: 'tag_2')
    create(:tag, name: 'tag_3')
    create(:project, name: 'Some Name', slug: 'some-name', tags: ['tag_1'])
    expect_any_instance_of(Mutations::UpdateProjectTags).to(receive(:org_owner_check_for_project).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { tagNames: ['tag_2', 'tag_3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectTags']['project'])
        .to(eq({ "slug" => "some-name", "tags" => ["tag_2", "tag_3"] }))
      expect(result['data']['updateProjectTags']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:project, name: 'Some Name', slug: 'some-name', tags: ['tag_1'])

    result = execute_graphql(
      mutation,
      variables: { tagNames: ['tag_2', 'tag_3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateProjectTags']['project'])
        .to(eq(nil))
      expect(result['data']['updateProjectTags']['errors'])
        .to(eq(['Must have proper rights to update a project']))
    end
  end
end
