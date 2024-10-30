# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::CreateSector, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation CreateSector(
        $name: String!,
        $slug: String!,
        $isDisplayable: Boolean!,
        $originId: Int,
        $parentSectorId: Int,
        $locale: String
      ) {
        createSector(
          name: $name,
          slug: $slug,
          isDisplayable: $isDisplayable,
          originId: $originId,
          parentSectorId: $parentSectorId,
          locale: $locale
        ) {
            sector {
              name
              slug
              locale
              isDisplayable
            }
            errors
          }
        }
    GQL
  end

  let(:sector_query) do
    <<~GQL
      query Sector($slug: String!) {
        sector(slug: $slug) {
          name
          slug
          originId
        }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    origin = create(:origin, name: "Example Origin", slug: "example_origin")
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        isDisplayable: false,
        originId: origin.id,
        parentSectorId: nil
      },
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Some name", "slug" => "some-name", "locale" => "en", "isDisplayable" => false }))
    end
  end

  it 'is successful - missing locale will store the correct with current locale value' do
    create(:origin, name: "Manually Entered", slug: "manually-entered")
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)

    # Creating new sector using random origin id
    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Without Locale",
        slug: "without-locale",
        isDisplayable: false
      }
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Without Locale", "slug" => "without-locale", "locale" => "en", "isDisplayable" => false }))
    end
  end

  it 'is successful - valid locale will store the correct value' do
    create(:origin, name: "Manually Entered", slug: "manually-entered")
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)

    # Creating new sector using random origin id
    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "DE Locale",
        slug: "de-locale",
        isDisplayable: false,
        locale: 'de'
      }
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "DE Locale", "slug" => "de-locale", "locale" => "de", "isDisplayable" => false }))
    end
  end

  it 'is successful - random locale will be replaced with current locale value' do
    create(:origin, name: "Manually Entered", slug: "manually-entered")
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)

    # Creating new sector using random origin id
    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Random Locale",
        slug: "random-locale",
        isDisplayable: false,
        locale: 'some-non-locale-value'
      }
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Random Locale", "slug" => "random-locale", "locale" => "en", "isDisplayable" => false }))
    end
  end

  it 'is successful - setting the origin to default when value is random' do
    origin = create(:origin, name: "Manually Entered", slug: "manually-entered")
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)

    # Creating new sector using random origin id
    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Random Origin",
        slug: "random-origin",
        isDisplayable: false,
        originId: origin.id + 99
      }
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Random Origin", "slug" => "random-origin", "locale" => "en", "isDisplayable" => false }))
    end

    query_result = execute_graphql_as_user(
      admin_user,
      sector_query,
      variables: {
        slug: "random-origin"
      }
    )

    aggregate_failures do
      expect(query_result['data']['sector'])
        .to(eq({ "name" => "Random Origin", "slug" => "random-origin", "originId" => origin.id }))
    end
  end

  it 'is successful - setting the origin to default value of manually entered' do
    origin = create(:origin, name: "Manually Entered", slug: "manually-entered")
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)

    # Creating new sector using only required fields.
    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        isDisplayable: false
      }
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Some name", "slug" => "some-name", "locale" => "en", "isDisplayable" => false }))
    end

    query_result = execute_graphql_as_user(
      admin_user,
      sector_query,
      variables: {
        slug: "some-name"
      }
    )

    aggregate_failures do
      expect(query_result['data']['sector'])
        .to(eq({ "name" => "Some name", "slug" => "some-name", "originId" => origin.id }))
    end
  end

  it 'is successful - creating sector with duplicate name' do
    origin = create(:origin, name: "Example Origin", slug: "example_origin")
    graph_variables = {
      name: "Some name",
      slug: "",
      isDisplayable: false,
      originId: origin.id,
      parentSectorId: nil
    }
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: graph_variables,
    )

    # First sector creation should use normal slug.
    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Some name", "slug" => "some-name", "locale" => "en", "isDisplayable" => false }))
    end

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: graph_variables,
    )

    # The following create should add -duplicate-X to the slug when creating sector using the same name.
    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name-duplicate-0",
          "locale" => "en",
          "isDisplayable" => false
        }))
    end

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: graph_variables,
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({
          "name" => "Some name",
          "slug" => "some-name-duplicate-1",
          "locale" => "en",
          "isDisplayable" => false
        }))
    end
  end

  it 'is successful - admin can update sector name and slug remains the same' do
    origin = create(:origin, name: "Example Origin", slug: "example_origin")
    create(:sector, name: "Some name", slug: "some-name", is_displayable: false, origin_id: origin.id, locale: 'en')
    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        name: "Some new name",
        slug: "some-name",
        isDisplayable: false,
        originId: origin.id,
        parentSectorId: nil
      }
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(eq({ "name" => "Some new name", "slug" => "some-name", "locale" => "en", "isDisplayable" => false }))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation,
      variables: {
        name: "Some name",
        slug: "some-name",
        isDisplayable: false,
        originId: 1,
        parentSectorId: nil
      }
    )

    aggregate_failures do
      expect(result['data']['createSector']['sector'])
        .to(be(nil))
    end
  end
end
