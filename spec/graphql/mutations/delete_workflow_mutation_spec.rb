# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::DeleteWorkflow, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation DeleteWorkflow ($id: ID!) {
        deleteWorkflow(id: $id) {
            workflow {
              id
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:workflow, id: 1000, name: 'Some Workflow', slug: 'some-workflow')
    expect_any_instance_of(Mutations::DeleteWorkflow).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteWorkflow']['workflow'])
        .to(eq({ 'id' => '1000' }))
      expect(result['data']['deleteWorkflow']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:workflow, id: 1000, name: 'Some Workflow', slug: 'some-workflow')

    result = execute_graphql(
      mutation,
      variables: { id: '1000' },
    )

    aggregate_failures do
      expect(result['data']['deleteWorkflow']['workflow'])
        .to(be(nil))
      expect(result['data']['deleteWorkflow']['errors'])
        .to(eq(["Must be admin to delete a workflow."]))
    end
  end
end
