# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateCandidateDataset, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateCandidateDataset(
        $name: String!
        $slug: String!
        $dataUrl: String!
        $dataVisualizationUrl: String
        $dataType: String!
        $submitterEmail: String!
        $description: String!
        $captcha: String!
      ) {
        createCandidateDataset (
          name: $name
          slug: $slug
          dataUrl: $dataUrl
          dataVisualizationUrl: $dataVisualizationUrl
          dataType: $dataType
          submitterEmail: $submitterEmail
          description: $description
          captcha: $captcha
        ) {
          candidateDataset {
            name
            slug
            dataUrl
            dataVisualizationUrl
            description
          }
          errors
        }
      }
    GQL
  end

  it 'creates candidate dataset - user is logged in' do
    user = create(:user, email: 'user@gmail.com')
    expect_any_instance_of(Mutations::CreateCandidateDataset).to(receive(:captcha_verification).and_return(true))

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        name: 'Some Name',
        slug: '',
        dataUrl: 'some.url',
        dataType: 'dataset',
        dataVisualizationUrl: '',
        submitterEmail: 'some@email.com',
        description: 'Some description',
        captcha: ''
      }
    )

    aggregate_failures do
      expect(result['data']['createCandidateDataset']['candidateDataset'])
        .to(eq({
          "dataUrl" => "some.url",
          "dataVisualizationUrl" => "",
          "description" => "Some description",
          "name" => "Some Name",
          "slug" => "some_name"
        }))
      expect(result['data']['createCandidateDataset']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - captcha do not match' do
    user = create(:user, email: 'user@gmail.com')
    expect_any_instance_of(Mutations::CreateCandidateDataset).to(receive(:captcha_verification).and_return(false))

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        name: 'Some Name',
        slug: '',
        dataUrl: 'some.url',
        dataType: 'dataset',
        dataVisualizationUrl: '',
        submitterEmail: 'some@email.com',
        description: 'Some description',
        captcha: ''
      }
    )

    aggregate_failures do
      expect(result['data']['createCandidateDataset']['candidateDataset'])
        .to(be(nil))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: {
        name: 'Some Name',
        slug: '',
        dataUrl: 'some.url',
        dataType: 'dataset',
        dataVisualizationUrl: '',
        submitterEmail: 'some@email.com',
        description: 'Some description',
        captcha: ''
      }
    )

    aggregate_failures do
      expect(result['data']['createCandidateDataset']['candidateDataset'])
        .to(be(nil))
      expect(result['data']['createCandidateDataset']['errors'])
        .to(eq(['Must be logged in to create an candidate dataset']))
    end
  end
end
