# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOrganizationOffices, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateOrganizationOffices (
        $offices: [JSON!]!
        $slug: String!
        ) {
          updateOrganizationOffices (
            offices: $offices
            slug: $slug
          ) {
            organization {
              slug
              offices {
                city
                name
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:organization, name: 'Some Name', slug: 'some-name', offices: [])
    country_1 = create(:country, name: "Country 1", code_longer: "C01", code: "C1", id: 1)
    country_2 = create(:country, name: "Country 2", code_longer: "C02", code: "C2", id: 2)

    province_1 = create(:province, name: "Region 1", id: 1, country: country_1)
    province_2 = create(:province, name: "Region 2", id: 2, country: country_2)

    create(:city, name: "City 1", id: 1, province: province_1)
    create(:city, name: "City 2", id: 2, province: province_2)

    offices_data = [{
      cityName: "City 1",
      provinceName: "Region 1",
      countryCode: "C1",
      countryName: "Country 1",
      latitude: 93.224,
      longitude: 23.22323
    }, {
      cityName: "City 2",
      provinceName: "Region 2",
      countryCode: "C2",
      countryName: "Country 2",
      latitude: -28.423,
      longitude: -100.77
    }]

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: { offices: offices_data, slug: 'some-name' }
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationOffices']['organization'])
        .to(eq({
          "offices" => [{
            "city" => "City 1",
            "name" => "City 1, Region 1, C1"
          }, {
            "city" => "City 2",
            "name" => "City 2, Region 2, C2"
          }],
          "slug" => "some-name"
        }))
      expect(result['data']['updateOrganizationOffices']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as organization owner' do
    create(:organization, id: 10004, name: 'Some Name', slug: 'some-name', offices: [], website: 'website.com')
    country_3 = create(:country, name: "Country 3", code_longer: "C03", code: "C3", id: 3)
    country_4 = create(:country, name: "Country 4", code_longer: "C04", code: "C4", id: 4)

    province_3 = create(:province, name: "Region 3", id: 1, country: country_3)
    province_4 = create(:province, name: "Region 4", id: 2, country: country_4)

    create(:city, name: "City 3", id: 1, province: province_3)
    create(:city, name: "City 4", id: 2, province: province_4)

    # Note, that we are using 'regionName'. This is actually the province, but it is coming
    # from the geocoding as regionName

    offices_data = [{
      cityName: "City 3",
      regionName: "Region 3",
      countryCode: "C3",
      countryName: "Country 3",
      latitude: 93.224,
      longitude: 23.22323
    }, {
      cityName: "City 4",
      regionName: "Region 4",
      countryCode: "C4",
      countryName: "Country 4",
      latitude: -28.423,
      longitude: -100.77
    }]

    owner_user = create(
      :user,
      organization_id: 10004,
      email: 'admin-user@website.com',
      roles: ['organization_owner']
    )

    result = execute_graphql_as_user(
      owner_user,
      mutation,
      variables: { offices: offices_data, slug: 'some-name' }
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationOffices']['organization'])
        .to(eq({
          "offices" => [{
            "city" => "City 3",
            "name" => "City 3, Region 3, C3"
          }, {
            "city" => "City 4",
            "name" => "City 4, Region 4, C4"
          }],
          "slug" => "some-name"
        }))
      expect(result['data']['updateOrganizationOffices']['errors']).to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:organization, name: 'Some Name', slug: 'some-name', offices: [])

    offices_data = [{
      cityName: "City 1",
      regionName: "Region 1",
      countryCode: "C1",
      countryName: "Country 1",
      latitude: 93.224,
      longitude: 23.22323
    }, {
      cityName: "City 2",
      regionName: "Region 2",
      countryCode: "C2",
      countryName: "Country 2",
      latitude: -28.423,
      longitude: -100.77
    }]

    result = execute_graphql(
      mutation,
      variables: { offices: offices_data, slug: 'some-name' }
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationOffices']['organization']).to(be(nil))
      expect(result['data']['updateOrganizationOffices']['errors'])
        .to(eq(['Editing organization is not allowed.']))
    end
  end

  it 'is fails - user has not proper rigths' do
    create(:organization, name: 'Some Name', slug: 'some-name', offices: [])
    country_1 = create(:country, name: "Country 1", code_longer: "C01", code: "C1", id: 1)
    country_2 = create(:country, name: "Country 2", code_longer: "C02", code: "C1", id: 2)

    province_1 = create(:province, name: "Region 1", id: 1, country: country_1)
    province_2 = create(:province, name: "Region 2", id: 2, country: country_2)

    create(:city, name: "City 1", id: 1, province: province_1)
    create(:city, name: "City 2", id: 2, province: province_2)

    offices_data = [{
      cityName: "City 1",
      regionName: "Region 1",
      countryCode: "C1",
      countryName: "Country 1",
      latitude: 93.224,
      longitude: 23.22323
    }, {
      cityName: "City 2",
      regionName: "Region 2",
      countryCode: "C2",
      countryName: "Country 2",
      latitude: -28.423,
      longitude: -100.77
    }]

    result = execute_graphql(
      mutation,
      variables: { offices: offices_data, slug: 'some-name' }
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationOffices']['organization']).to(be(nil))
      expect(result['data']['updateOrganizationOffices']['errors'])
        .to(eq(['Editing organization is not allowed.']))
    end
  end
end
