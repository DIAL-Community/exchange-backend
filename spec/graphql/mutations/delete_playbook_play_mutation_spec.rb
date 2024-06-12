# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeletePlaybookPlay, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeletePlaybookPlay (
        $playbookSlug: String!
        $playSlug: String!
        $owner: String!
      ) {
        deletePlaybookPlay(
          playbookSlug: $playbookSlug
          playSlug: $playSlug
          owner: $owner
        ) {
          playbook {
            id
            plays {
              id
            }
          }
          errors
        }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])
    playbook = create(:playbook, id: 1000, name: 'Some Playbook', slug: 'some-playbook', owned_by: 'Some Owner')
    some_play = create(:play, name: 'Some Play', slug: 'some-play', owned_by: 'Some Owner')
    some_more_play = create(:play, name: 'Some More Play', slug: 'some-more-play')
    yet_more_play = create(:play, name: 'Yet More Play', slug: 'yet_more-play')

    playbook.plays << some_play
    playbook.plays << some_more_play
    playbook.plays << yet_more_play

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { playbookSlug: 'some-playbook', playSlug: 'some-play', owner: 'Some Owner' }
    )

    aggregate_failures do
      expect(result['data']['deletePlaybookPlay']['playbook']['id']).to(eq('1000'))
      expect(result['data']['deletePlaybookPlay']['playbook']['plays'].length).to(eq(2))
      expect(result['data']['deletePlaybookPlay']['errors']).to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:playbook, id: 1000, name: 'Some Playbook', slug: 'some-playbook', owned_by: 'Some Owner')

    result = execute_graphql(
      mutation,
      variables: { playbookSlug: 'some-playbook', playSlug: 'some-play', owner: 'Some Owner' }
    )

    aggregate_failures do
      expect(result['data']['deletePlaybookPlay']['playbook']).to(be(nil))
      expect(result['data']['deletePlaybookPlay']['errors'])
        .to(eq(["Must be an admin or an editor to remove play from a playbook."]))
    end
  end
end
