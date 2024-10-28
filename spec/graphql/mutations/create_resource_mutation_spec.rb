# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateResource, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateResource(
        $name: String!
        $slug: String!
        $description: String
        $publishedDate: ISO8601Date!
        $featured: Boolean
        $resourceLink: String
        $resourceType: String
        $resourceTopics: [String!]
        $sourceName: String
        $sourceWebsite: String
        $showInExchange: Boolean
        $showInWizard: Boolean
        $organizationSlug: String
        $authors: [JSON!]
      ) {
        createResource(
          name: $name
          slug: $slug
          description: $description
          publishedDate: $publishedDate
          featured: $featured
          resourceLink: $resourceLink
          resourceType: $resourceType
          resourceTopics: $resourceTopics
          sourceName: $sourceName
          sourceWebsite: $sourceWebsite
          showInExchange: $showInExchange
          showInWizard: $showInWizard
          organizationSlug: $organizationSlug
          authors: $authors
        ) {
            resource {
              name
              slug
              showInExchange
              showInWizard
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is an admin' do
    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])
    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some Name",
        slug: "some-name",
        publishedDate: '2023-10-10T00:00:00.000Z',
        authorName: 'Nyoman Ribeka',
        showInExchange: false,
        showInWizard: true
      }
    )

    aggregate_failures do
      expect(result['data']['createResource']['resource'])
        .to(eq({ "name" => "Some Name", "slug" => "some-name", "showInExchange" => false, "showInWizard" => true }))
    end
  end

  it 'is successful - user editing data.' do
    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])
    create(:resource, id: 1000, name: 'Some Resource', slug: 'some-resource')
    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Updated name",
        slug: "some-resource",
        publishedDate: '2023-10-10T00:00:00.000Z',
        authorName: 'Nyoman Ribeka',
        showInExchange: false,
        showInWizard: true
      }
    )

    aggregate_failures do
      expect(result['data']['createResource']['resource'])
        .to(eq({
          "name" => "Updated name",
          "slug" => "some-resource",
          "showInExchange" => false,
          "showInWizard" => true
        }))
    end
  end

  it 'is not successful - not logged in.' do
    result = execute_graphql(
      mutation,
      variables: {
        name: "Some Name",
        slug: "some-name",
        publishedDate: '2023-10-10T00:00:00.000Z',
        authorName: 'Nyoman Ribeka',
        showInExchange: false,
        showInWizard: true
      }
    )

    # Returned data will be updated with data from the geocode result.
    aggregate_failures do
      expect(result['data']['createResource']['resource']).to(be(nil))
      expect(result['data']['createResource']['errors'])
        .to(eq(['Creating / editing resource is not allowed.']))
    end
  end

  it 'is not successful - unprivileged user.' do
    standard_user = create(:user, email: 'user@gmail.com', roles: [:user])
    result = execute_graphql_as_user(
      standard_user,
      mutation,
      variables: {
        name: "Some Name",
        slug: "some-name",
        publishedDate: '2023-10-10T00:00:00.000Z',
        authorName: 'Nyoman Ribeka',
        showInExchange: false,
        showInWizard: true
      }
    )

    # Returned data will be updated with data from the geocode result.
    aggregate_failures do
      expect(result['data']['createResource']['resource']).to(be(nil))
      expect(result['data']['createResource']['errors'])
        .to(eq(['Creating / editing resource is not allowed.']))
    end
  end
end
