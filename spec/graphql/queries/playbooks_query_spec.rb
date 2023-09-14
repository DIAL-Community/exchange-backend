# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::PlaybooksQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query {
        playbooks{
          id
          slug
          author
          name
        }
      }
    GQL
  end

  it 'pulling playbooks is successful' do
    create(:playbook, name: 'Some Draft Playbook')
    create(:playbook, name: 'Some Published Playbook')
    create(:playbook, name: 'Some More Published Playbook')
    create(:playbook, name: 'Another Published Playbook')

    result = execute_graphql(
      query
    )

    aggregate_failures do
      expect(result['data']['playbooks'].count)
        .to(eq(4))
    end
  end
end
