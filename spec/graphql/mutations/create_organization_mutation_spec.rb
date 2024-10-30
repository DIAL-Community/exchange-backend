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
        $hasStorefront: Boolean
      ) {
        createOrganization(
          name: $name
          slug: $slug
          aliases: []
          website: $website
          hasStorefront: $hasStorefront
          whenEndorsed: "2022-01-01"
          endorserLevel: "none"
          description: "Some organization description."
        ) {
            organization {
              name
              slug
              website
              hasStorefront
            }
            errors
          }
        }
    GQL
  end

  it 'is successful - admin can create and edit organization' do
    admin = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])
    result = execute_graphql_as_user(
      admin,
      mutation,
      variables: {
        slug: "",
        name: "Some name",
        website: "some.website.com"
      }
    )

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name",
          "website" => "some.website.com",
          "hasStorefront" => false
        }))
    end

    result = execute_graphql_as_user(
      admin,
      mutation,
      variables: {
        slug: "some-name",
        name: "Some updated name",
        website: "website.com"
      }
    )

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(eq({
          "name" => "Some updated name",
          "slug" => "some-name",
          "website" => "website.com",
          "hasStorefront" => false
        }))
    end
  end

  it 'is successful - organization owner can update organization and slug stay the same' do
    org = create(:organization, name: "Some name", slug: "some-name", website: "some.website.com")
    owner = create(
      :user,
      email: 'user@some.website.com',
      roles: ['user', 'organization_owner'],
      organization_id: org.id
    )

    result = execute_graphql_as_user(
      owner,
      mutation,
      variables: {
        slug: "some-name",
        name: "Some updated name",
        website: "website.com"
      }
    )

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(eq({
          "name" => "Some updated name",
          "slug" => "some-name",
          "website" => "website.com",
          "hasStorefront" => false
        }))
    end
  end

  it 'is successful - admin can update organization name and slug stay the same' do
    admin = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])
    create(:organization, name: "Some name", slug: "some-name", website: "some.website.com")

    result = execute_graphql_as_user(
      admin,
      mutation,
      variables: {
        slug: "some-name",
        name: "Some updated name",
        website: "website.com"
      }
    )

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(eq({
          "name" => "Some updated name",
          "slug" => "some-name",
          "website" => "website.com",
          "hasStorefront" => false
        }))
    end
  end

  it 'is successful - user with matching email allowed to create and get assigned as owner' do
    user = create(:user, email: 'user@website.com', roles: ['user'])

    result = execute_graphql_as_user(
      user,
      mutation,
      operation_name: 'CreateStorefront',
      variables: {
        slug: '',
        name: "Some storefront name",
        website: "website.com",
        "hasStorefront": true
      }
    )

    # Refresh current user record
    user.reload

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(eq({
          "name" => "Some storefront name",
          "slug" => "some-storefront-name",
          "website" => "website.com",
          "hasStorefront" => true
        }))
      expect(user.organization_id).not_to(eq(nil))
      expect(user.roles).to(eq(['user', 'organization_owner']))
    end

    # User is now an organization owner, editing owned organization is allowed
    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        slug: 'some-storefront-name',
        name: "Some updated storefront name",
        website: "some.website.com",
        "hasStorefront": true
      }
    )

    # Refresh current user record
    user.reload

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(eq({
          "name" => "Some updated storefront name",
          "slug" => "some-storefront-name",
          "website" => "some.website.com",
          "hasStorefront" => true
        }))
      expect(user.organization_id).not_to(eq(nil))
      expect(user.roles).to(eq(['user', 'organization_owner']))
    end
  end

  it 'is failed - standard user with non matching email host not allowed to create storefront' do
    user = create(:user, email: 'user@non-website.com', roles: ['user'])

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        slug: '',
        name: "Some storefront name",
        website: "website.com",
        "hasStorefront": true
      }
    )

    # Refresh current user record
    user.reload

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(be(nil))
      expect(user.organization_id).to(eq(nil))
      expect(user.roles).to(eq(['user']))
    end
  end

  it 'is failed - standard user not allowed to edit existing record' do
    user = create(:user, email: 'user@website.com', roles: ['user'])
    create(:organization, name: "Some name", slug: "some-name", website: "some.website.com")

    # Editing standard organization and making storefront of it
    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        slug: 'some-name',
        name: "Some storefront name",
        website: "website.com",
        "hasStorefront": true
      }
    )

    # Refresh current user record
    user.reload

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(be(nil))
      expect(user.organization_id).to(eq(nil))
      expect(user.roles).to(eq(['user']))
    end

    # Editing standard organization
    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        slug: 'some-name',
        name: "Some storefront name",
        website: "website.com"
      }
    )

    # Refresh current user record
    user.reload

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(be(nil))
      expect(user.organization_id).to(eq(nil))
      expect(user.roles).to(eq(['user']))
    end
  end

  it 'is failed - non-user is not allowed to create / edit organization' do
    create(:organization, name: "Some name", slug: "some-name", website: "some.website.com")

    result = execute_graphql(
      mutation,
      variables: {
        slug: '',
        name: "Some storefront name",
        website: "website.com",
        "hasStorefront": true
      }
    )

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(be(nil))
    end

    result = execute_graphql(
      mutation,
      variables: {
        slug: 'some-name',
        name: "Some storefront name",
        website: "website.com",
        "hasStorefront": true
      }
    )

    aggregate_failures do
      expect(result['data']['createOrganization']['organization'])
        .to(be(nil))
    end
  end
end
