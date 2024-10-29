# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateUseCaseStepDatasets, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateUseCaseStepDatasets (
        $datasetSlugs: [String!]!
        $slug: String!
        ) {
          updateUseCaseStepDatasets (
            datasetSlugs: $datasetSlugs
            slug: $slug
          ) {
            useCaseStep {
              slug
              datasets {
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
      datasets: [create(:dataset, slug: 'dataset-1', name: 'Dataset 1')]
    )
    create(:dataset, slug: 'dataset-2', name: 'Dataset 2')
    create(:dataset, slug: 'dataset-3', name: 'Dataset 3')

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { datasetSlugs: ['dataset-2', 'dataset-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepDatasets']['useCaseStep'])
        .to(eq({ "slug" => "some-name", "datasets" => [{ "slug" => "dataset-2" }, { "slug" => "dataset-3" }] }))
      expect(result['data']['updateUseCaseStepDatasets']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    create(
      :use_case_step,
      name: 'Some Name',
      slug: 'some-name',
      datasets: [create(:dataset, slug: 'dataset-1', name: 'Dataset 1')]
    )
    create(:dataset, slug: 'dataset-2', name: 'Dataset 2')
    create(:dataset, slug: 'dataset-3', name: 'Dataset 3')

    editor_user = create(:user, email: 'user@gmail.com', roles: ['content_editor'])

    result = execute_graphql_as_user(
      editor_user,
      mutation,
      variables: { datasetSlugs: ['dataset-2', 'dataset-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepDatasets']['useCaseStep'])
        .to(eq({ "slug" => "some-name", "datasets" => [{ "slug" => "dataset-2" }, { "slug" => "dataset-3" }] }))
      expect(result['data']['updateUseCaseStepDatasets']['errors']).to(eq([]))
    end
  end

  it 'is fails - user has not proper rights' do
    create(
      :use_case_step,
      name: 'Some Name',
      slug: 'some-name',
      datasets: [create(:dataset, slug: 'dataset-1', name: 'Dataset 1')]
    )
    create(:dataset, slug: 'dataset-2', name: 'Dataset 2')
    create(:dataset, slug: 'dataset-3', name: 'Dataset 3')

    result = execute_graphql(
      mutation,
      variables: { datasetSlugs: ['dataset-2', 'dataset-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepDatasets']['useCaseStep']).to(eq(nil))
      expect(result['data']['updateUseCaseStepDatasets']['errors'])
        .to(eq(['Editing use case step is not allowed.']))
    end
  end

  it 'is fails - user is not logged in' do
    create(
      :use_case_step,
      name: 'Some Name',
      slug: 'some-name',
      datasets: [create(:dataset, slug: 'dataset-1', name: 'Dataset 1')]
    )
    create(:dataset, slug: 'dataset-2', name: 'Dataset 2')
    create(:dataset, slug: 'dataset-3', name: 'Dataset 3')

    result = execute_graphql(
      mutation,
      variables: { datasetSlugs: ['dataset-2', 'dataset-3'], slug: 'some-name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepDatasets']['useCaseStep']).to(eq(nil))
      expect(result['data']['updateUseCaseStepDatasets']['errors'])
        .to(eq(['Editing use case step is not allowed.']))
    end
  end
end
