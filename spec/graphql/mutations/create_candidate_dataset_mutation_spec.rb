# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateCandidateDataset, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateCandidateDataset(
        $name: String!
        $slug: String!
        $website: String!
        $visualizationUrl: String
        $datasetType: String!
        $submitterEmail: String!
        $description: String!
        $captcha: String!
      ) {
        createCandidateDataset (
          name: $name
          slug: $slug
          website: $website
          visualizationUrl: $visualizationUrl
          datasetType: $datasetType
          submitterEmail: $submitterEmail
          description: $description
          captcha: $captcha
        ) {
          candidateDataset {
            name
            slug
            website
            visualizationUrl
            description
          }
          errors
        }
      }
    GQL
  end

  it 'creates candidate dataset - user is logged in' do
    create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)

    user = create(:user, email: 'user@gmail.com')
    expect_any_instance_of(Mutations::CreateCandidateDataset).to(receive(:captcha_verification).and_return(true))

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        name: 'Some Name',
        slug: '',
        website: 'some.url',
        visualizationUrl: '',
        datasetType: 'dataset',
        submitterEmail: 'some@email.com',
        description: 'Some description',
        captcha: ''
      }
    )

    aggregate_failures do
      expect(result['data']['createCandidateDataset']['candidateDataset'])
        .to(eq({
          "website" => "some.url",
          "visualizationUrl" => "",
          "description" => "Some description",
          "name" => "Some Name",
          "slug" => "some-name"
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
        website: 'some.url',
        visualizationUrl: '',
        datasetType: 'dataset',
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
        website: 'some.url',
        visualizationUrl: '',
        datasetType: 'dataset',
        submitterEmail: 'some@email.com',
        description: 'Some description',
        captcha: ''
      }
    )

    aggregate_failures do
      expect(result['data']['createCandidateDataset']['candidateDataset'])
        .to(be(nil))
      expect(result['data']['createCandidateDataset']['errors'])
        .to(eq(['Creating / editing candidate dataset is not allowed.']))
    end
  end
end
