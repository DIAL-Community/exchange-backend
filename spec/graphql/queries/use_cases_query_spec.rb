# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Queries::UseCasesQuery, type: :graphql) do
  let(:query) do
    <<~GQL
      query UseCasesForSector ($sectorSlugs: [String!]!) {
        useCasesForSector (sectorSlugs: $sectorSlugs) {
          name
        }
      }
    GQL
  end

  it 'pulls use cases assigned to sector' do
    create(:sector, name: 'Some Sector', slug: 'some_sector', id: 1001)
    create(:use_case, name: 'Use Case 1', sector_id: 1001, maturity: 'PUBLISHED')
    create(:use_case, name: 'Use Case 2', sector_id: 1001, maturity: 'BETA')

    result = execute_graphql(
      query,
      variables: { sectorSlugs: "some_sector" }
    )

    aggregate_failures do
      expect(result['data']['useCasesForSector'])
        .to(eq([{ "name" => "Use Case 1" }]))
    end
  end
end
