# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateUseCaseStepDatasets, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateUseCaseStepDatasets (
        $datasetsSlugs: [String!]!
        $slug: String!
        ) {
          updateUseCaseStepDatasets (
            datasetsSlugs: $datasetsSlugs
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
    create(:use_case_step, name: 'Some Name', slug: 'some_name',
                      datasets: [create(:dataset, slug: 'dataset_1', name: 'Dataset 1')])
    create(:dataset, slug: 'dataset_2', name: 'Dataset 2')
    create(:dataset, slug: 'dataset_3', name: 'Dataset 3')
    expect_any_instance_of(Mutations::UpdateUseCaseStepDatasets).to(receive(:an_admin).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { datasetsSlugs: ['dataset_2', 'dataset_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepDatasets']['useCaseStep'])
        .to(eq({ "slug" => "some_name", "datasets" => [{ "slug" => "dataset_2" }, { "slug" => "dataset_3" }] }))
      expect(result['data']['updateUseCaseStepDatasets']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as content editor' do
    create(:use_case_step, name: 'Some Name', slug: 'some_name',
                      datasets: [create(:dataset, slug: 'dataset_1', name: 'Dataset 1')])
    create(:dataset, slug: 'dataset_2', name: 'Dataset 2')
    create(:dataset, slug: 'dataset_3', name: 'Dataset 3')
    expect_any_instance_of(Mutations::UpdateUseCaseStepDatasets).to(receive(:a_content_editor).and_return(true))

    result = execute_graphql(
      mutation,
      variables: { datasetsSlugs: ['dataset_2', 'dataset_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepDatasets']['useCaseStep'])
        .to(eq({ "slug" => "some_name", "datasets" => [{ "slug" => "dataset_2" }, { "slug" => "dataset_3" }] }))
      expect(result['data']['updateUseCaseStepDatasets']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user has not proper rights' do
    expect_any_instance_of(Mutations::UpdateUseCaseStepDatasets).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::UpdateUseCaseStepDatasets).to(receive(:a_content_editor).and_return(false))

    create(:use_case_step, name: 'Some Name', slug: 'some_name',
                     datasets: [create(:dataset, slug: 'dataset_1', name: 'Dataset 1')])
    create(:dataset, slug: 'dataset_2', name: 'Dataset 2')
    create(:dataset, slug: 'dataset_3', name: 'Dataset 3')

    result = execute_graphql(
      mutation,
      variables: { datasetsSlugs: ['dataset_2', 'dataset_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepDatasets']['useCaseStep'])
        .to(eq(nil))
      expect(result['data']['updateUseCaseStepDatasets']['errors'])
        .to(eq(['Must be admin or content editor to update use case step']))
    end
  end

  it 'is fails - user is not logged in' do
    create(:use_case_step, name: 'Some Name', slug: 'some_name',
              datasets: [create(:dataset, slug: 'dataset_1', name: 'Dataset 1')])
    create(:dataset, slug: 'dataset_2', name: 'Dataset 2')
    create(:dataset, slug: 'dataset_3', name: 'Dataset 3')

    result = execute_graphql(
      mutation,
      variables: { datasetsSlugs: ['dataset_2', 'dataset_3'], slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateUseCaseStepDatasets']['useCaseStep'])
        .to(eq(nil))
      expect(result['data']['updateUseCaseStepDatasets']['errors'])
        .to(eq(['Must be admin or content editor to update use case step']))
    end
  end
end
