# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateOpportunityUseCases, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation UpdateOpportunityUseCases (
        $useCaseSlugs: [String!]!
        $slug: String!
      ) {
        updateOpportunityUseCases (
          useCaseSlugs: $useCaseSlugs
          slug: $slug
        ) {
          opportunity {
            slug
            useCases {
              slug
            }
          }
          errors
        }
      }
    GQL
  end

  it 'should allow admin user to update opportunity record' do
    opportunity = create(
      :opportunity,
      name: 'Opportunity A',
      description: 'Some description',
      web_address: 'http://example.com',
      opportunity_status: Opportunity.opportunity_status_types[:OPEN],
      opportunity_type: Opportunity.opportunity_type_types[:OTHER],
      contact_name: 'Fake Name',
      contact_email: 'fake@email.com'
    )
    first_use_case = create(:use_case, slug: 'first_use_case', name: 'First UseCase')
    second_use_case = create(:use_case, slug: 'second_use_case', name: 'Second UseCase')
    admin_user = create(:user, email: 'user@gmail.com', roles: [:admin])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        useCaseSlugs: [first_use_case.slug, second_use_case.slug],
        slug: opportunity.slug
      }
    )

    aggregate_failures do
      expect(result['data']['updateOpportunityUseCases']['opportunity'])
        .to(eq({
          "slug" => opportunity.slug,
          "useCases" => [
            { "slug" => first_use_case.slug },
            { "slug" => second_use_case.slug }
          ]
        }))
      expect(result['data']['updateOpportunityUseCases']['errors'])
        .to(eq([]))
    end
  end

  it 'should prevent non-admin user to update opportunity record' do
    opportunity = create(
      :opportunity,
      name: 'Opportunity A',
      description: 'Some description',
      web_address: 'http://example.com',
      opportunity_status: Opportunity.opportunity_status_types[:OPEN],
      opportunity_type: Opportunity.opportunity_type_types[:OTHER],
      contact_name: 'Fake Name',
      contact_email: 'fake@email.com'
    )
    first_use_case = create(:use_case, slug: 'first_use_case', name: 'First UseCase')
    second_use_case = create(:use_case, slug: 'second_use_case', name: 'Second UseCase')
    standard_user = create(:user, email: 'user@gmail.com', roles: [:user])

    result = execute_graphql_as_user(
      standard_user,
      mutation,
      variables: {
        useCaseSlugs: [first_use_case.slug, second_use_case.slug],
        slug: opportunity.slug
      }
    )

    aggregate_failures do
      expect(result['data']['updateOpportunityUseCases']['opportunity'])
        .to(eq(nil))
      expect(result['data']['updateOpportunityUseCases']['errors'])
        .to(eq(['Must have proper rights to update an opportunity']))
    end
  end
end
