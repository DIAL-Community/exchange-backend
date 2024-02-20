# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeletePlaybook, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeletePlaybook ($id: ID!) {
        deletePlaybook(id: $id) {
            playbook {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:playbook, id: 1000, name: 'Some Playbook', slug: 'some-playbook')
    expect_any_instance_of(Mutations::DeletePlaybook).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deletePlaybook']['playbook'])
        .to(eq({ 'id' => '1000' }))
      expect(result['data']['deletePlaybook']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:playbook, id: 1000, name: 'Some Playbook', slug: 'some-playbook')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deletePlaybook']['playbook'])
        .to(be(nil))
      expect(result['data']['deletePlaybook']['errors'])
        .to(eq(["Must be admin to delete a playbook."]))
    end
  end
end
