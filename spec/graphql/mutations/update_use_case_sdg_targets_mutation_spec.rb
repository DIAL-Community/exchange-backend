# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateUseCaseSdgTargets, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateUseCaseSdgTargets (
        $sdgTargetIds: [Int!]!
        $slug: String!
        ) {
          updateUseCaseSdgTargets (
            sdgTargetIds: $sdgTargetIds
            slug: $slug
          ) {
            useCase {
              slug
              sdgTargets {
                id
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(
      :use_case,
      name: 'Some Name',
      slug: 'some-name',
      sdg_targets: [create(:sdg_target, slug: 'sdg-target-1', name: 'SDG Target 1', id: 1)]
    )
    create(:sdg_target, slug: 'sdg-target-2', name: 'SDG Target 2', id: 2)
    create(:sdg_target, slug: 'sdg-target-3', name: 'SDG Target 3', id: 3)

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { sdgTargetIds: [2, 3], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseSdgTargets']['useCase'])
        .to(eq({ "slug" => "some-name", "sdgTargets" => [{ "id" => "2" }, { "id" => "3" }] }))
      expect(result['data']['updateUseCaseSdgTargets']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    create(
      :use_case,
      name: 'Some Name',
      slug: 'some-name',
      sdg_targets: [create(:sdg_target, slug: 'sdg-target-1', name: 'SDG Target 1', id: 1)]
    )
    create(:sdg_target, slug: 'sdg-target-2', name: 'SDG Target 2', id: 2)
    create(:sdg_target, slug: 'sdg-target-3', name: 'SDG Target 3', id: 3)

    editor_user = create(:user, email: 'user@gmail.com', roles: ['content_editor'])

    result = execute_graphql_as_user(
      editor_user,
      mutation,
      variables: { sdgTargetIds: [2, 3], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseSdgTargets']['useCase'])
        .to(eq({ "slug" => "some-name", "sdgTargets" => [{ "id" => "2" }, { "id" => "3" }] }))
      expect(result['data']['updateUseCaseSdgTargets']['errors']).to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(
      :use_case,
      name: 'Some Name',
      slug: 'some-name',
      sdg_targets: [create(:sdg_target, slug: 'sdg-target-1', name: 'SDG Target 1', id: 1)]
    )
    create(:sdg_target, slug: 'sdg-target-2', name: 'SDG Target 2', id: 2)
    create(:sdg_target, slug: 'sdg-target-3', name: 'SDG Target 3', id: 3)

    result = execute_graphql(
      mutation,
      variables: { sdgTargetIds: [2, 3], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseSdgTargets']['useCase']).to(eq(nil))
      expect(result['data']['updateUseCaseSdgTargets']['errors'])
        .to(eq(['Editing use case is not allowed.']))
    end
  end
end
