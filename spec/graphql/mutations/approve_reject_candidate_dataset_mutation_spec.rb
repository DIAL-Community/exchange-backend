# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::ApproveRejectCandidateDataset, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation ApproveRejectCandidateDataset (
        $slug: String!
        $action: String!
      ) {
        approveRejectCandidateDataset (
          slug: $slug
          action: $action
        ) {
            candidateDataset {
              rejected
            }
            errors
          }
        }
    GQL
  end

  it 'approves candidate dataset - user is an admin' do
    create(:candidate_dataset, name: 'Some Random Candidate', slug: 'some-random-candidate')

    user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        slug: 'some-random-candidate',
        action: 'APPROVE'
      }
    )

    aggregate_failures do
      expect(result['data']['approveRejectCandidateDataset']['candidateDataset'])
        .to(eq({ "rejected" => false }))
      expect(result['data']['approveRejectCandidateDataset']['errors'])
        .to(eq([]))
    end
  end

  it 'rejects candidate dataset - user is an admin' do
    create(:candidate_dataset, name: 'Some Random Candidate', slug: 'some-random-candidate')

    user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        slug: 'some-random-candidate',
        action: 'REJECT'
      }
    )

    aggregate_failures do
      expect(result['data']['approveRejectCandidateDataset']['candidateDataset'])
        .to(eq({ "rejected" => true }))
      expect(result['data']['approveRejectCandidateDataset']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not an admin' do
    create(:candidate_dataset, name: 'Some Random Candidate', slug: 'some-random-candidate')

    user = create(:user, email: 'user@gmail.com')

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        slug: 'some-random-candidate',
        action: 'REJECT'
      }
    )

    aggregate_failures do
      expect(result['data']['approveRejectCandidateDataset']['candidateDataset'])
        .to(be(nil))
      expect(result['data']['approveRejectCandidateDataset']['errors'])
        .to(eq(['Must be admin to approve or reject candidate dataset']))
    end
  end

  it 'fails - user is not logged in' do
    create(:candidate_dataset, name: 'Some Random Candidate', slug: 'some-random-candidate')

    result = execute_graphql(
      mutation,
      variables: {
        slug: 'some-random-candidate',
        action: 'REJECT'
      }
    )

    aggregate_failures do
      expect(result['data']['approveRejectCandidateDataset']['candidateDataset'])
        .to(be(nil))
      expect(result['data']['approveRejectCandidateDataset']['errors'])
        .to(eq(['Must be admin to approve or reject candidate dataset']))
    end
  end

  it 'fails - wrong action provided' do
    create(:candidate_dataset, name: 'Some Random Candidate', slug: 'some-random-candidate')

    user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        slug: 'some-random-candidate',
        action: 'UPDATE'
      }
    )

    aggregate_failures do
      expect(result['data']['approveRejectCandidateDataset']['candidateDataset'])
        .to(be(nil))
      expect(result['data']['approveRejectCandidateDataset']['errors'])
        .to(eq(['Wrong action provided']))
    end
  end
end
