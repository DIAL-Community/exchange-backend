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
    create(:use_case, id: 1000, name: 'Some UseCase', slug: 'some_use_case')
    expect_any_instance_of(Mutations::DeleteUseCase).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
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
    create(:use_case, id: 1000, name: 'Some UseCase', slug: 'some_use_case')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteUseCase']['useCase'])
        .to(be(nil))
      expect(result['data']['deleteUseCase']['errors'])
        .to(eq(["Must be admin to delete a use case."]))
    end
  end
end
