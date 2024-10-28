# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteUseCase, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteUseCase ($id: ID!) {
        deleteUseCase(id: $id) {
            useCase {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:use_case, id: 1000, name: 'Some UseCase', slug: 'some-use_case')
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteUseCase']['useCase'])
        .to(eq({ 'id' => '1000' }))
      expect(result['data']['deleteUseCase']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:use_case, id: 1000, name: 'Some UseCase', slug: 'some-use_case')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteUseCase']['useCase'])
        .to(be(nil))
      expect(result['data']['deleteUseCase']['errors'])
        .to(eq(["Deleting use case is not allowed."]))
    end
  end
end
