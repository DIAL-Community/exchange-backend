# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::ApproveRejectCandidateRole, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation ApproveRejectCandidateRole (
        $candidateRoleId: ID!
        $action: String!
        ) {
        approveRejectCandidateRole (
          candidateRoleId: $candidateRoleId
          action: $action
        ) {
            candidateRole
            {
              rejected
            }
            errors
          }
        }
    GQL
  end

  it 'approves candidate role for product - user is an admin' do
    create(:product, id: 1001)
    create(:user, email: 'nonadmin@gmail.com')
    candidate_role = create(
      :candidate_role,
      email: 'nonadmin@gmail.com',
      roles: ['product_owner'],
      rejected: nil,
      product_id: 1001
    )

    user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        candidateRoleId: candidate_role.id,
        action: 'APPROVE'
      }
    )

    aggregate_failures do
      expect(result['data']['approveRejectCandidateRole']['candidateRole'])
        .to(eq({ "rejected" => false }))
      expect(result['data']['approveRejectCandidateRole']['errors'])
        .to(eq([]))
    end
  end

  it 'approves candidate role for dataset - user is an admin' do
    create(:dataset, id: 1001)
    create(:user, email: 'nonadmin@gmail.com')
    candidate_role = create(:candidate_role, email: 'nonadmin@gmail.com',
                                             roles: ['dataset_user'],
                                             rejected: nil,
                                             dataset_id: 1001)

    user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        candidateRoleId: candidate_role.id,
        action: 'APPROVE'
      }
    )

    aggregate_failures do
      expect(result['data']['approveRejectCandidateRole']['candidateRole'])
        .to(eq({ "rejected" => false }))
      expect(result['data']['approveRejectCandidateRole']['errors'])
        .to(eq([]))
    end
  end

  it 'approves candidate role for organization - user is an admin' do
    create(:organization, id: 1001)
    create(:user, email: 'nonadmin@gmail.com')
    candidate_role = create(:candidate_role, email: 'nonadmin@gmail.com',
                                             roles: ['organization_owner'],
                                             rejected: nil,
                                             organization_id: 1001)

    user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        candidateRoleId: candidate_role.id,
        action: 'APPROVE'
      }
    )

    aggregate_failures do
      expect(result['data']['approveRejectCandidateRole']['candidateRole'])
        .to(eq({ "rejected" => false }))
      expect(result['data']['approveRejectCandidateRole']['errors'])
        .to(eq([]))
    end
  end

  it 'rejects candidate dataset - user is an admin' do
    create(:organization, id: 1001)
    candidate_role = create(:candidate_role, email: 'nonadmin@gmail.com',
                                             roles: ['organization_owner'],
                                             rejected: nil,
                                             organization_id: 1001)

    user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        candidateRoleId: candidate_role.id,
        action: 'REJECT'
      }
    )

    aggregate_failures do
      expect(result['data']['approveRejectCandidateRole']['candidateRole'])
        .to(eq({ "rejected" => true }))
      expect(result['data']['approveRejectCandidateRole']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not an admin' do
    create(:organization, id: 1001)
    candidate_role = create(:candidate_role, email: 'nonadmin@gmail.com',
                                             roles: ['organization_owner'],
                                             rejected: nil,
                                             organization_id: 1001)

    user = create(:user, email: 'user@gmail.com')

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        candidateRoleId: candidate_role.id,
        action: 'REJECT'
      }
    )

    aggregate_failures do
      expect(result['data']['approveRejectCandidateRole']['candidateRole'])
        .to(be(nil))
      expect(result['data']['approveRejectCandidateRole']['errors'])
        .to(eq(['Must be admin to approve or reject candidate role']))
    end
  end

  it 'fails - user is not logged in' do
    create(:organization, id: 1001)
    candidate_role = create(:candidate_role, email: 'nonadmin@gmail.com',
                                             roles: ['organization_owner'],
                                             rejected: nil,
                                             organization_id: 1001)

    result = execute_graphql(
      mutation,
      variables: {
        candidateRoleId: candidate_role.id,
        action: 'REJECT'
      }
    )

    aggregate_failures do
      expect(result['data']['approveRejectCandidateRole']['candidateRole'])
        .to(be(nil))
      expect(result['data']['approveRejectCandidateRole']['errors'])
        .to(eq(['Must be admin to approve or reject candidate role']))
    end
  end

  it 'fails - wrong action provided' do
    create(:organization, id: 1001)
    candidate_role = create(:candidate_role, email: 'nonadmin@gmail.com',
                                             roles: ['organization_owner'],
                                             rejected: nil,
                                             organization_id: 1001)

    user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        candidateRoleId: candidate_role.id,
        action: 'UPDATE'
      }
    )

    aggregate_failures do
      expect(result['data']['approveRejectCandidateRole']['candidateRole'])
        .to(be(nil))
      expect(result['data']['approveRejectCandidateRole']['errors'])
        .to(eq(['Wrong action provided']))
    end
  end
end
