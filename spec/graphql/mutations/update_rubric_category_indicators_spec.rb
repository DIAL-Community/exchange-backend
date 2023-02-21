# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::UpdateRubricCategoryIndicators, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation updateRubricCategoryIndicators (
        $categoryIndicatorSlugs: [String!]!
        $rubricCategorySlug: String!
        ) {
        updateRubricCategoryIndicators(
          categoryIndicatorSlugs: $categoryIndicatorSlugs
          rubricCategorySlug: $rubricCategorySlug
        ) {
            rubricCategory
            {
              categoryIndicators{
                slug
                rubricCategoryId
              }
            }
            errors
          }
        }
    GQL
  end

  it 'updates category indicator - user is logged in as admin' do
    expect_any_instance_of(Mutations::UpdateRubricCategoryIndicators).to(receive(:an_admin).and_return(true))

    create(:rubric_category, slug: 'replaced_rubric', name: 'Replaced Rubric', weight: 0.2)
    create(:rubric_category, slug: 'test_rubric', name: 'Test Rubric', weight: 0.4)
    create(:category_indicator, slug: 'test_indicator_1', name: 'Test Indicator 1',
           rubric_category: RubricCategory.find_by(slug: 'replaced_rubric'))
    create(:category_indicator, slug: 'test_indicator_2', name: 'Test Indicator 2',
           rubric_category: RubricCategory.find_by(slug: 'replaced_rubric'))
    # additional category indicators - with replaced and new label for testing
    create(:category_indicator, slug: 'test_indicator_remain', name: 'Test Indicator To Remain',
           rubric_category: RubricCategory.find_by(slug: 'test_rubric'))
    create(:category_indicator, slug: 'test_indicator_delete', name: 'Test Indicator To Delete',
           rubric_category: RubricCategory.find_by(slug: 'test_rubric'))

    result = execute_graphql(
      mutation,
      variables: { categoryIndicatorSlugs: %w[test_indicator_1 test_indicator_2 test_indicator_remain],
                   rubricCategorySlug: "test_rubric" },
    )

    aggregate_failures do
      expect(result['data']['updateRubricCategoryIndicators']['rubricCategory']['categoryIndicators'])
        .to(eq([{ 'slug' => 'test_indicator_remain',
                  'rubricCategoryId' => RubricCategory.find_by(slug: 'test_rubric').id },
                { 'slug' => 'test_indicator_1', 'rubricCategoryId' => RubricCategory.find_by(slug: 'test_rubric').id },
                { 'slug' => 'test_indicator_2',
                  'rubricCategoryId' => RubricCategory.find_by(slug: 'test_rubric').id }]))
      expect(result['data']['updateRubricCategoryIndicators']['errors'])
        .to(eq([]))
    end
  end

  it 'updates category indicator - user is logged in as content editor' do
    expect_any_instance_of(Mutations::UpdateRubricCategoryIndicators).to(receive(:a_content_editor).and_return(true))

    create(:rubric_category, slug: 'replaced_rubric', name: 'Replaced Rubric', weight: 0.2)
    create(:rubric_category, slug: 'test_rubric', name: 'Test Rubric', weight: 0.4)

    create(:category_indicator, slug: 'test_indicator_1', name: 'Test Indicator 1',
           rubric_category: RubricCategory.find_by(slug: 'replaced_rubric'))
    create(:category_indicator, slug: 'test_indicator_2', name: 'Test Indicator 2',
           rubric_category: RubricCategory.find_by(slug: 'replaced_rubric'))

    result = execute_graphql(
      mutation,
      variables: { categoryIndicatorSlugs: %w[test_indicator_1 test_indicator_2],
                   rubricCategorySlug: "test_rubric" },
    )

    aggregate_failures do
      expect(result['data']['updateRubricCategoryIndicators']['rubricCategory']['categoryIndicators'])
        .to(eq([{ 'slug' => 'test_indicator_1',
                  'rubricCategoryId' => RubricCategory.find_by(slug: 'test_rubric').id },
                { 'slug' => 'test_indicator_2',
                  'rubricCategoryId' => RubricCategory.find_by(slug: 'test_rubric').id }]))
      expect(result['data']['updateRubricCategoryIndicators']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user has not proper rights' do
    expect_any_instance_of(Mutations::UpdateRubricCategoryIndicators).to(receive(:an_admin).and_return(false))
    expect_any_instance_of(Mutations::UpdateRubricCategoryIndicators).to(receive(:a_content_editor).and_return(false))

    create(:rubric_category, slug: 'replaced_rubric', name: 'Replaced Rubric', weight: 0.2)
    create(:rubric_category, slug: 'test_rubric', name: 'Test Rubric', weight: 0.4)

    create(:category_indicator, slug: 'test_indicator_1', name: 'Test Indicator 1',
           rubric_category: RubricCategory.find_by(slug: 'replaced_rubric'))
    create(:category_indicator, slug: 'test_indicator_2', name: 'Test Indicator 2',
           rubric_category: RubricCategory.find_by(slug: 'replaced_rubric'))

    result = execute_graphql(
      mutation,
      variables: { categoryIndicatorSlugs: %w[test_indicator_1 test_indicator_2],
                   rubricCategorySlug: "test_rubric" },
    )

    aggregate_failures do
      expect(result['data']['updateRubricCategoryIndicators']['categoryIndicators'])
        .to(be(nil))
      expect(result['data']['updateRubricCategoryIndicators']['errors'])
        .to(eq(['Must be admin or content editor to update rubric category.']))
    end
  end

  it 'fails - user is not logged in' do
    create(:rubric_category, slug: 'replaced_rubric', name: 'Replaced Rubric', weight: 0.2)
    create(:rubric_category, slug: 'test_rubric', name: 'Test Rubric', weight: 0.4)

    create(:category_indicator, slug: 'test_indicator_1', name: 'Test Indicator 1',
           rubric_category: RubricCategory.find_by(slug: 'replaced_rubric'))
    create(:category_indicator, slug: 'test_indicator_2', name: 'Test Indicator 2',
           rubric_category: RubricCategory.find_by(slug: 'replaced_rubric'))

    result = execute_graphql(
      mutation,
      variables: { categoryIndicatorSlugs: %w[test_indicator_1 test_indicator_2],
                   rubricCategorySlug: "test_rubric" },
    )

    aggregate_failures do
      expect(result['data']['updateRubricCategoryIndicators']['categoryIndicators'])
        .to(be(nil))
      expect(result['data']['updateRubricCategoryIndicators']['errors'])
        .to(eq(['Must be admin or content editor to update rubric category.']))
    end
  end
end
