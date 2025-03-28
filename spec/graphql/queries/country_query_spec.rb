# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::CountryQuery, type: :graphql) do
  let(:country_query) do
    <<~GQL
      query Country($slug: String!) {
        country(slug: $slug) {
          name
          slug
          code
          codeLonger
        }
      }
    GQL
  end

  it 'pulling correct country by the slug of the country.' do
    create(:country, id: 1000, name: 'Some Country', slug: 'some-country')
    result = execute_graphql(
      country_query,
      variables: {
        slug: "some-country"
      }
    )

    aggregate_failures do
      expect(result['data']['country']['name']).to(eq('Some Country'))
    end
  end

  it 'pulling random slug will return invalid data.' do
    create(:country, id: 1000, name: 'Some Country', slug: 'some-country')
    result = execute_graphql(
      country_query,
      variables: {
        slug: "some-country_with_wrong_slug"
      }
    )

    aggregate_failures do
      expect(result['data']['country']).to(eq(nil))
    end
  end
end
