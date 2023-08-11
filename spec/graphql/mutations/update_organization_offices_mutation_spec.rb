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
                latitude
                longitude
                name
              }
            }
            errors
          }
      }
    GQL
  end

  it 'is successful - user is logged in as admin' do
    create(:organization, name: 'Some Name', slug: 'some_name', offices: [])
    country_1 = create(:country, name: "Country 1", code_longer: "C1", id: 1)
    country_2 = create(:country, name: "Country 2", code_longer: "C2", id: 2)

    region_1 = create(:region, name: "Region 1", id: 1, country_id: country_1.id)
    region_2 = create(:region, name: "Region 2", id: 2, country_id: country_2.id)

    create(:city, name: "City 1", id: 1, region_id: region_1.id)
    create(:city, name: "City 2", id: 2, region_id: region_2.id)
    expect_any_instance_of(Mutations::UpdateOrganizationOffices).to(receive(:an_admin)
                                                                .and_return(true))

    offices_data = [{ cityName: "City 1", countryName: "Country 1", countryCode: "C1",
                      regionName: "Region 1", latitude: 1.0, longitude: 1.0 },
                    { cityName: "City 2", countryName: "Country 2", countryCode: "C2",
                      regionName: "Region 2", latitude: 2.0, longitude: 2.0 }]

    result = execute_graphql(
      mutation,
      variables: { offices: offices_data, slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationOffices']['organization'])
        .to(eq({ "offices" => [{ "city" => "City 1", "latitude" => "1.0", "longitude" => "1.0",
                                 "name" => "City 1, Region 1, C1" },
                               { "city" => "City 2", "latitude" => "2.0", "longitude" => "2.0",
                                 "name" => "City 2, Region 2, C2" }], "slug" => "some_name" }))
      expect(result['data']['updateOrganizationOffices']['errors'])
        .to(eq([]))
    end
  end

  it 'is successful - user is logged in as organization owner' do
    create(:organization, name: 'Some Name', slug: 'some_name', offices: [])
    country_1 = create(:country, name: "Country 1", code_longer: "C1", id: 1)
    country_2 = create(:country, name: "Country 2", code_longer: "C2", id: 2)

    region_1 = create(:region, name: "Region 1", id: 1, country_id: country_1.id)
    region_2 = create(:region, name: "Region 2", id: 2, country_id: country_2.id)

    create(:city, name: "City 1", id: 1, region_id: region_1.id)
    create(:city, name: "City 2", id: 2, region_id: region_2.id)
    expect_any_instance_of(Mutations::UpdateOrganizationOffices).to(receive(:an_org_owner)
                                                                .and_return(true))

    offices_data = [{ cityName: "City 1", countryName: "Country 1", countryCode: "C1",
                      regionName: "Region 1", latitude: 3.0, longitude: 3.0 },
                    { cityName: "City 2", countryName: "Country 2", countryCode: "C2",
                      regionName: "Region 2", latitude: 4.0, longitude: 4.0 }]

    result = execute_graphql(
      mutation,
      variables: { offices: offices_data, slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationOffices']['organization'])
        .to(eq({ "offices" => [{ "city" => "City 1", "latitude" => "3.0", "longitude" => "3.0",
                                 "name" => "City 1, Region 1, C1" },
                               { "city" => "City 2", "latitude" => "4.0", "longitude" => "4.0",
                                 "name" => "City 2, Region 2, C2" }], "slug" => "some_name" }))
      expect(result['data']['updateOrganizationOffices']['errors'])
        .to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:organization, name: 'Some Name', slug: 'some_name', offices: [])

    offices_data = [{ cityName: "City 1", countryName: "Country 1", countryCode: "C1",
                      regionName: "Region 1", latitude: 1.0, longitude: 1.0 },
                    { cityName: "City 2", countryName: "Country 2", countryCode: "C2",
                      regionName: "Region 2", latitude: 2.0, longitude: 2.0 }]

    result = execute_graphql(
      mutation,
      variables: { offices: offices_data, slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationOffices']['organization'])
        .to(be(nil))
      expect(result['data']['updateOrganizationOffices']['errors'])
        .to(eq(['Must be admin or organization owner to update an organization']))
    end
  end

  it 'is fails - user has not proper rigths' do
    create(:organization, name: 'Some Name', slug: 'some_name', offices: [])
    country_1 = create(:country, name: "Country 1", code_longer: "C1", id: 1)
    country_2 = create(:country, name: "Country 2", code_longer: "C2", id: 2)

    region_1 = create(:region, name: "Region 1", id: 1, country_id: country_1.id)
    region_2 = create(:region, name: "Region 2", id: 2, country_id: country_2.id)

    create(:city, name: "City 1", id: 1, region_id: region_1.id)
    create(:city, name: "City 2", id: 2, region_id: region_2.id)
    expect_any_instance_of(Mutations::UpdateOrganizationOffices).to(receive(:an_admin)
                                                                .and_return(false))
    expect_any_instance_of(Mutations::UpdateOrganizationOffices).to(receive(:an_org_owner)
                                                                .and_return(false))

    offices_data = [{ cityName: "City 1", countryName: "Country 1", countryCode: "C1",
                      regionName: "Region 1", latitude: 3.0, longitude: 3.0 },
                    { cityName: "City 2", countryName: "Country 2", countryCode: "C2",
                      regionName: "Region 2", latitude: 4.0, longitude: 4.0 }]

    result = execute_graphql(
      mutation,
      variables: { offices: offices_data, slug: 'some_name' },
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationOffices']['organization'])
        .to(be(nil))
      expect(result['data']['updateOrganizationOffices']['errors'])
        .to(eq(['Must be admin or organization owner to update an organization']))
    end
  end
end
