# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::UsersQuery, type: :graphql) do
  let(:user_roles_query) do
    <<~GQL
      query {
        userRoles
      }
    GQL
  end

  it 'pulls the list of available user roles' do
    expect_any_instance_of(Queries::UserRolesQuery).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      user_roles_query
    )

    aggregate_failures do
      expect(result['data']['userRoles'].count).to(eq(10))
    end
  end

  it 'returns nil if user is not an admin' do
    expect_any_instance_of(Queries::UserRolesQuery).to(receive(:an_admin).and_return(false))

    result = execute_graphql(
      user_roles_query
    )

    aggregate_failures do
      expect(result['data']['userRoles']).to(be(nil))
    end
  end

  let(:user_email_check_query) do
    <<~GQL
      query UserEmailCheck ($email: String!) {
        userEmailCheck (email: $email)
      }
    GQL
  end

  it 'returns true if provided email exists' do
    create(:user, email: 'some@email.email')

    result = execute_graphql(
      user_email_check_query,
      variables: { email: 'some@email.email' }
    )

    aggregate_failures do
      expect(result['data']['userEmailCheck']).to(be(true))
    end
  end

  it 'returns false if provided email does not exist' do
    result = execute_graphql(
      user_email_check_query,
      variables: { email: 'some@email.com' }
    )

    aggregate_failures do
      expect(result['data']['userEmailCheck']).to(be(false))
    end
  end
end
