# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::CandidateDatasetQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query CandidateDatasets ($search: String!) {
        candidateDatasets (search: $search) {
          name
        }
      }
    GQL
  end

  it 'searches existing candidate datasets' do
    create(:candidate_dataset, name: 'Some Random Candidate')

    user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      user,
      query,
      variables: { search: "Random" },
      operation_context: VIEWING_CONTEXT
    )

    aggregate_failures do
      expect(result['data']['candidateDatasets'].count).to(eq(1))
    end
  end

  it 'fails - user is not logged in' do
    create(:candidate_dataset, name: 'Some Random Candidate')

    result = execute_graphql_as_user(
      nil,
      query,
      variables: { search: "Random" },
      operation_context: VIEWING_CONTEXT
    )

    aggregate_failures do
      expect(result['data']).to(eq(nil))
      expect(result['errors']).not_to(eq(nil))
    end
  end

  it 'fails - user is not an admin' do
    create(:candidate_dataset, name: 'Some Random Candidate')

    user = create(:user, email: 'user@gmail.com')

    result = execute_graphql_as_user(
      user,
      query,
      variables: { search: "Random" },
      operation_context: VIEWING_CONTEXT
    )

    aggregate_failures do
      expect(result['data']).to(eq(nil))
      expect(result['errors']).not_to(eq(nil))
    end
  end
end
