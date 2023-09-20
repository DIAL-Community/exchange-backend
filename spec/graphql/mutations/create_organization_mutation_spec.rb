# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateOrganization, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateOrganization(
        $name: String!
        $slug: String!
        $website: String
        ) {
        createOrganization(
          name: $name
          slug: $slug
          aliases: {}
          website: $website
          isMni: false
          hasStorefront: true
          whenEndorsed: "2022-01-01"
          endorserLevel: "none"
          description: ""
        ) {
            organization
            {
              name
              slug
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])
    result = execute_graphql_as_user(
      user,
      mutation,
      variables: { name: "Some name", slug: "some_name", website: "some.website.com" }
    )

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(eq({ "name" => "Some name", "slug" => "some_name" }))
    end
  end

  it 'is successful - organization owner can update organization name and slug remains the same' do
    org = create(:organization, name: "Some name", slug: "some_name", website: "some.website.com")
    user = create(:user, email: 'user@some.website.com', roles: ['user', 'org_user'], organization_id: org.id)

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: { name: "Some new name", slug: "some_name", website: 'gmail.com' }
    )

    puts "Result: #{result.inspect}"

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(eq({ "name" => "Some new name", "slug" => "some_name" }))
    end
  end

  it 'is successful - user can create storefront record and assigned as owner' do
    user = create(:user, email: 'user@website.com', roles: ['user'])

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: { name: "Some storefront", slug: "", website: 'website.com' }
    )

    # Refresh current user record
    user.reload

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(eq({ "name" => "Some storefront", "slug" => "some_storefront" }))
      expect(user.organization_id).not_to(eq(nil))
      expect(user.roles).to(eq(['user', 'org_user']))
    end
  end

  it 'is successful - admin can update organization name and slug remains the same' do
    user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])
    create(:organization, name: "Some name", slug: "some_name", website: "some.website.com")

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: { name: "Some new name", slug: "some_name" }
    )

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(eq({ "name" => "Some new name", "slug" => "some_name" }))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: { name: "Some name", slug: "some_name" }
    )

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(be(nil))
    end
  end
end
