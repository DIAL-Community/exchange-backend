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
    create(:organization, name: 'Some Name', slug: 'some_name', offices: [])
    country_1 = create(:country, name: "Country 1", code_longer: "C01", code: "C1", id: 1)
    country_2 = create(:country, name: "Country 2", code_longer: "C02", code: "C2", id: 2)

    region_1 = create(:region, name: "Region 1", id: 1, country: country_1)
    region_2 = create(:region, name: "Region 2", id: 2, country: country_2)

    create(:city, name: "City 1", id: 1, region: region_1)
    create(:city, name: "City 2", id: 2, region: region_2)
    expect_any_instance_of(Mutations::UpdateOrganizationOffices).to(receive(:an_admin)
                                                                .and_return(true))

    offices_data = [{
      cityName: "City 1",
      regionName: "Region 1",
      countryCode: "C1",
      countryName: "Country 1"
    }, {
      cityName: "City 2",
      regionName: "Region 2",
      countryCode: "C2",
      countryName: "Country 2"
    }]

    result = execute_graphql(
      mutation,
      variables: { offices: offices_data, slug: 'some_name' }
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
          "slug" => "some_name"
        }))
      expect(result['data']['updateOrganizationOffices']['errors']).to(eq([]))
    end
  end

  it 'is successful - user is logged in as organization owner' do
    create(:organization, name: 'Some Name', slug: 'some_name', offices: [])
    country_3 = create(:country, name: "Country 3", code_longer: "C03", code: "C3", id: 3)
    country_4 = create(:country, name: "Country 4", code_longer: "C04", code: "C4", id: 4)

    region_3 = create(:region, name: "Region 3", id: 1, country: country_3)
    region_4 = create(:region, name: "Region 4", id: 2, country: country_4)

    create(:city, name: "City 3", id: 1, region: region_3)
    create(:city, name: "City 4", id: 2, region: region_4)
    expect_any_instance_of(Mutations::UpdateOrganizationOffices).to(receive(:an_org_owner)
                                                                .and_return(true))

    offices_data = [{
      cityName: "City 3",
      regionName: "Region 3",
      countryCode: "C3",
      countryName: "Country 3"
    }, {
      cityName: "City 4",
      regionName: "Region 4",
      countryCode: "C4",
      countryName: "Country 4"
    }]

    result = execute_graphql(
      mutation,
      variables: { offices: offices_data, slug: 'some_name' }
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
          "slug" => "some_name"
        }))
      expect(result['data']['updateOrganizationOffices']['errors']).to(eq([]))
    end
  end

  it 'is fails - user is not logged in' do
    create(:organization, name: 'Some Name', slug: 'some_name', offices: [])

    offices_data = [{
      cityName: "City 1",
      regionName: "Region 1",
      countryCode: "C1",
      countryName: "Country 1"
    }, {
      cityName: "City 2",
      regionName: "Region 2",
      countryCode: "C2",
      countryName: "Country 2"
    }]

    result = execute_graphql(
      mutation,
      variables: { offices: offices_data, slug: 'some_name' }
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationOffices']['organization']).to(be(nil))
      expect(result['data']['updateOrganizationOffices']['errors'])
        .to(eq(['Must be admin or organization owner to update an organization']))
    end
  end

  it 'is fails - user has not proper rigths' do
    create(:organization, name: 'Some Name', slug: 'some_name', offices: [])
    country_1 = create(:country, name: "Country 1", code_longer: "C01", code: "C1", id: 1)
    country_2 = create(:country, name: "Country 2", code_longer: "C02", code: "C1", id: 2)

    region_1 = create(:region, name: "Region 1", id: 1, country: country_1)
    region_2 = create(:region, name: "Region 2", id: 2, country: country_2)

    create(:city, name: "City 1", id: 1, region: region_1)
    create(:city, name: "City 2", id: 2, region: region_2)
    expect_any_instance_of(Mutations::UpdateOrganizationOffices).to(receive(:an_admin)
                                                                .and_return(false))
    expect_any_instance_of(Mutations::UpdateOrganizationOffices).to(receive(:an_org_owner)
                                                                .and_return(false))

    offices_data = [{
      cityName: "City 1",
      regionName: "Region 1",
      countryCode: "C1",
      countryName: "Country 1"
    }, {
      cityName: "City 2",
      regionName: "Region 2",
      countryCode: "C2",
      countryName: "Country 2"
    }]

    result = execute_graphql(
      mutation,
      variables: { offices: offices_data, slug: 'some_name' }
    )

    aggregate_failures do
      expect(result['data']['updateOrganizationOffices']['organization']).to(be(nil))
      expect(result['data']['updateOrganizationOffices']['errors'])
        .to(eq(['Must be admin or organization owner to update an organization']))
    end
  end
end
