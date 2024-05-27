# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::PlaybooksQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query($owner: String!) {
        playbooks(owner: $owner) {
          id
          slug
          author
          name
        }
      }
    GQL
  end

  it 'pulling playbooks is successful' do
    create(:playbook, name: 'Some Draft Playbook', owned_by: 'Some Owner')
    create(:playbook, name: 'Some Published Playbook', owned_by: 'Some Owner')
    create(:playbook, name: 'Some More Published Playbook', owned_by: 'Some Owner')
    create(:playbook, name: 'Another Published Playbook')

    result = execute_graphql(
      query,
      variables: { "owner": "Some Owner" }
    )

    aggregate_failures do
      expect(result['data']['playbooks'].count).to(eq(3))
    end
  end
end
