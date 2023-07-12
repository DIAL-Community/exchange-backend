# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOrganizationContacts, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation($contacts: JSON!, $slug: String!) {
        updateOrganizationContacts(
          contacts: $contacts
          slug: $slug
        ) {
          organization {
            slug
            contacts {
              slug
            }
          }
          errors
        }
      }
    GQL
  end

  it 'successful to assign contacts for admin user' do
    first = create(:contact, name: 'First Person', slug: 'first_person')
    second = create(:contact, name: 'Second Person', slug: 'second_person')

    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])
    organization = create(:organization, name: 'Graph Organization', slug: 'graph_organization')

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { contacts: [first, second], slug: organization.slug },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationContacts']['organization'])
        .to(eq({ "contacts" => [{ "slug" => first.slug }, { "slug" => second.slug }], "slug" => organization.slug }))
    end
  end

  it 'failed to assign contacts for non-admin user' do
    first = create(:contact, name: 'First Person', slug: 'first_person')
    second = create(:contact, name: 'Second Person', slug: 'second_person')

    basic_user = create(:user, email: 'user@gmail.com', roles: [:user])
    organization = create(:organization, name: 'Graph Organization', slug: 'graph_organization')

    result = execute_graphql_as_user(
      basic_user,
      mutation,
      variables: { contacts: [first, second], slug: organization.slug },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationContacts']['organization'])
        .to(eq(nil))
    end
  end

  # TODO: Probably going to need to add more spec here.
  # * Test for organization owner.
  # * Test for unathorized users trying to do graph modification.
end
