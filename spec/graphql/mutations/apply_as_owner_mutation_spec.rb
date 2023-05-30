# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::ApplyAsOwner, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation ApplyAsOwner (
        $entity: String!
        $entityId: Int!
        ) {
        applyAsOwner (
          entity: $entity
          entityId: $entityId
        ) {
            candidateRole
            {
              email
              roles
              description
              productId
              organizationId
            }
            errors
          }
        }
    GQL
  end

  it 'creates product candidate role - user is logged in' do
    create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)
    user = create(:user, email: 'user@gmail.com')

    create(:product, name: "Some Product", slug: "some_product", id: 1001)

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        entity: 'PRODUCT',
        entityId: 1001
      }
    )

    aggregate_failures do
      expect(result['data']['applyAsOwner']['candidateRole'])
        .to(eq({
          "description" => "Product ownership requested from the new UX.",
          "email" => "user@gmail.com",
          "organizationId" => nil,
          "productId" => "1001",
          "roles" => ["product_user"]
        }))
      expect(result['data']['applyAsOwner']['errors'])
        .to(eq([]))
    end
  end

  it 'creates organization candidate role - user is logged in' do
    create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)
    user = create(:user, email: 'user@gmail.com')

    create(:organization, name: "Some Organization", slug: "some_organization", id: 1001)

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        entity: 'ORGANIZATION',
        entityId: 1001
      }
    )

    aggregate_failures do
      expect(result['data']['applyAsOwner']['candidateRole'])
        .to(eq({
          "description" => "Organization ownership requested from the new UX.",
          "email" => "user@gmail.com",
          "organizationId" => "1001",
          "productId" => nil,
          "roles" => ["org_user"]
        }))
      expect(result['data']['applyAsOwner']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user is not logged in' do
    create(:organization, name: "Some Organization", slug: "some_organization", id: 1001)

    result = execute_graphql(
      mutation,
      variables: {
        entity: 'ORGANIZATION',
        entityId: 1001
      }
    )

    aggregate_failures do
      expect(result['data']['applyAsOwner']['candidateRole'])
        .to(be(nil))
      expect(result['data']['applyAsOwner']['errors'])
        .to(eq(['Must be logged in to apply as owner']))
    end
  end

  it 'fails - provided wrong entity' do
    user = create(:user, email: 'user@gmail.com')

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        entity: 'BUILDING_BLOCK',
        entityId: 1001
      }
    )

    aggregate_failures do
      expect(result['data']['applyAsOwner']['candidateRole'])
        .to(be(nil))
      expect(result['data']['applyAsOwner']['errors'])
        .to(eq(['Wrong entity provided']))
    end
  end

  it 'fails - user is already a product owner' do
    user = create(:user, email: 'user@gmail.com', user_products: [1001])

    create(:product, name: "Some Product", slug: "some_product", id: 1001)

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        entity: 'PRODUCT',
        entityId: 1001
      }
    )

    aggregate_failures do
      expect(result['data']['applyAsOwner']['candidateRole'])
        .to(be(nil))
      expect(result['data']['applyAsOwner']['errors'])
        .to(eq(['You are owner of this product']))
    end
  end

  it 'fails - user is already an organization owner' do
    create(:organization, name: "Some Organization", slug: "some_organization", id: 1001, website: 'website.com')
    user = create(:user, email: 'user@website.com', organization_id: 1001)

    result = execute_graphql_as_user(
      user,
      mutation,
      variables: {
        entity: 'ORGANIZATION',
        entityId: 1001
      }
    )

    aggregate_failures do
      expect(result['data']['applyAsOwner']['candidateRole'])
        .to(be(nil))
      expect(result['data']['applyAsOwner']['errors'])
        .to(eq(['You are owner of this organization']))
    end
  end
end
