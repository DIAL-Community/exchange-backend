# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateUseCaseStepWorkflows, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateUseCaseStepWorkflows (
        $workflowSlugs: [String!]!
        $slug: String!
        ) {
          updateUseCaseStepWorkflows (
            workflowSlugs: $workflowSlugs
            slug: $slug
          ) {
            useCaseStep {
              slug
              workflows {
                slug
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(
      :use_case_step,
      name: 'Some Name',
      slug: 'some-name',
      workflows: [create(:workflow, slug: 'workflow-1', name: 'Workflow 1')]
    )
    create(:workflow, slug: 'workflow-2', name: 'Workflow 2')
    create(:workflow, slug: 'workflow-3', name: 'Workflow 3')

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { workflowSlugs: ['workflow-2', 'workflow-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepWorkflows']['useCaseStep'])
        .to(eq({ "slug" => "some-name", "workflows" => [{ "slug" => "workflow-2" }, { "slug" => "workflow-3" }] }))
      expect(result['data']['updateUseCaseStepWorkflows']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    create(
      :use_case_step,
      name: 'Some Name',
      slug: 'some-name',
      workflows: [create(:workflow, slug: 'workflow-1', name: 'Workflow 1')]
    )
    create(:workflow, slug: 'workflow-2', name: 'Workflow 2')
    create(:workflow, slug: 'workflow-3', name: 'Workflow 3')

    editor_user = create(:user, email: 'editor-user@gmail.com', roles: ['content_editor'])

    result = execute_graphql_as_user(
      editor_user,
      mutation,
      variables: { workflowSlugs: ['workflow-2', 'workflow-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepWorkflows']['useCaseStep'])
        .to(eq({ "slug" => "some-name", "workflows" => [{ "slug" => "workflow-2" }, { "slug" => "workflow-3" }] }))
      expect(result['data']['updateUseCaseStepWorkflows']['errors']).to(eq([]))
    end
  end

  it 'is fails - user has not proper rights' do
    create(
      :use_case_step,
      name: 'Some Name',
      slug: 'some-name',
      workflows: [create(:workflow, slug: 'workflow-1', name: 'Workflow 1')]
    )
    create(:workflow, slug: 'workflow-2', name: 'Workflow 2')
    create(:workflow, slug: 'workflow-3', name: 'Workflow 3')

    result = execute_graphql(
      mutation,
      variables: { workflowSlugs: ['workflow-2', 'workflow-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepWorkflows']['useCaseStep']).to(eq(nil))
      expect(result['data']['updateUseCaseStepWorkflows']['errors'])
        .to(eq(['Editing use case step is not allowed.']))
    end
  end

  it 'is fails - user is not logged in' do
    create(
      :use_case_step,
      name: 'Some Name',
      slug: 'some-name',
      workflows: [create(:workflow, slug: 'workflow-1', name: 'Workflow 1')]
    )
    create(:workflow, slug: 'workflow-2', name: 'Workflow 2')
    create(:workflow, slug: 'workflow-3', name: 'Workflow 3')

    result = execute_graphql(
      mutation,
      variables: { workflowSlugs: ['workflow-2', 'workflow-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepWorkflows']['useCaseStep']).to(eq(nil))
      expect(result['data']['updateUseCaseStepWorkflows']['errors'])
        .to(eq(['Editing use case step is not allowed.']))
    end
  end
end
