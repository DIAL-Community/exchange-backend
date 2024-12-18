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
    create(:rubric_category, slug: 'replaced-rubric', name: 'Replaced Rubric', weight: 0.2)
    create(:rubric_category, slug: 'test-rubric', name: 'Test Rubric', weight: 0.4)
    create(
      :category_indicator,
      slug: 'test-indicator-1',
      name: 'Test Indicator 1',
      rubric_category: RubricCategory.find_by(slug: 'replaced-rubric')
    )
    create(
      :category_indicator,
      slug: 'test-indicator-2',
      name: 'Test Indicator 2',
      rubric_category: RubricCategory.find_by(slug: 'replaced-rubric')
    )
    # additional category indicators - with replaced and new label for testing
    create(
      :category_indicator,
      slug: 'test-indicator-remain',
      name: 'Test Indicator To Remain',
      rubric_category: RubricCategory.find_by(slug: 'test-rubric')
    )
    create(
      :category_indicator,
      slug: 'test-indicator-delete',
      name: 'Test Indicator To Delete',
      rubric_category: RubricCategory.find_by(slug: 'test-rubric')
    )

    admin_user = create(:user, email: 'admin-user@gmail.com', roles: ['admin'])

    result = execute_graphql_as_user(
      admin_user,
      mutation,
      variables: {
        categoryIndicatorSlugs: ['test-indicator-1', 'test-indicator-2', 'test-indicator-remain'],
        rubricCategorySlug: 'test-rubric'
      },
    )

    aggregate_failures do
      expect(result['data']['updateRubricCategoryIndicators']['rubricCategory']['categoryIndicators'])
        .to(eq([
          { 'slug' => 'test-indicator-remain', 'rubricCategoryId' => RubricCategory.find_by(slug: 'test-rubric').id },
          { 'slug' => 'test-indicator-1', 'rubricCategoryId' => RubricCategory.find_by(slug: 'test-rubric').id },
          { 'slug' => 'test-indicator-2', 'rubricCategoryId' => RubricCategory.find_by(slug: 'test-rubric').id }
        ]))
      expect(result['data']['updateRubricCategoryIndicators']['errors']).to(eq([]))
    end
  end

  it 'updates category indicator - user is logged in as content editor' do
    create(:rubric_category, slug: 'replaced-rubric', name: 'Replaced Rubric', weight: 0.2)
    create(:rubric_category, slug: 'test-rubric', name: 'Test Rubric', weight: 0.4)

    create(
      :category_indicator,
      slug: 'test-indicator-1',
      name: 'Test Indicator 1',
      rubric_category: RubricCategory.find_by(slug: 'replaced-rubric')
    )
    create(
      :category_indicator,
      slug: 'test-indicator-2',
      name: 'Test Indicator 2',
      rubric_category: RubricCategory.find_by(slug: 'replaced-rubric')
    )

    editor_user = create(:user, email: 'user@gmail.com', roles: ['content_editor'])

    result = execute_graphql_as_user(
      editor_user,
      mutation,
      variables: { categoryIndicatorSlugs: ['test-indicator-1', 'test-indicator-2'],
                   rubricCategorySlug: 'test-rubric' },
    )

    aggregate_failures do
      expect(result['data']['updateRubricCategoryIndicators']['rubricCategory']['categoryIndicators'])
        .to(eq([
          { 'slug' => 'test-indicator-1', 'rubricCategoryId' => RubricCategory.find_by(slug: 'test-rubric').id },
          { 'slug' => 'test-indicator-2', 'rubricCategoryId' => RubricCategory.find_by(slug: 'test-rubric').id }
        ]))
      expect(result['data']['updateRubricCategoryIndicators']['errors'])
        .to(eq([]))
    end
  end

  it 'fails - user has not proper rights' do
    create(:rubric_category, slug: 'replaced-rubric', name: 'Replaced Rubric', weight: 0.2)
    create(:rubric_category, slug: 'test-rubric', name: 'Test Rubric', weight: 0.4)

    create(:category_indicator, slug: 'test-indicator-1', name: 'Test Indicator 1',
           rubric_category: RubricCategory.find_by(slug: 'replaced-rubric'))
    create(:category_indicator, slug: 'test-indicator-2', name: 'Test Indicator 2',
           rubric_category: RubricCategory.find_by(slug: 'replaced-rubric'))

    result = execute_graphql(
      mutation,
      variables: {
        categoryIndicatorSlugs: ['test-indicator-1', 'test-indicator-2'],
        rubricCategorySlug: 'test-rubric'
      },
    )

    aggregate_failures do
      expect(result['data']['updateRubricCategoryIndicators']['categoryIndicators']).to(be(nil))
      expect(result['data']['updateRubricCategoryIndicators']['errors'])
        .to(eq(['Editing rubric category is not allowed.']))
    end
  end

  it 'fails - user is not logged in' do
    create(:rubric_category, slug: 'replaced-rubric', name: 'Replaced Rubric', weight: 0.2)
    create(:rubric_category, slug: 'test-rubric', name: 'Test Rubric', weight: 0.4)

    create(
      :category_indicator,
      slug: 'test-indicator-1',
      name: 'Test Indicator 1',
      rubric_category: RubricCategory.find_by(slug: 'replaced-rubric')
    )
    create(
      :category_indicator,
      slug: 'test-indicator-2',
      name: 'Test Indicator 2',
      rubric_category: RubricCategory.find_by(slug: 'replaced-rubric')
    )

    result = execute_graphql(
      mutation,
      variables: {
        categoryIndicatorSlugs: ['test-indicator-1', 'test-indicator-2'],
        rubricCategorySlug: 'test-rubric'
      },
    )

    aggregate_failures do
      expect(result['data']['updateRubricCategoryIndicators']['categoryIndicators']).to(be(nil))
      expect(result['data']['updateRubricCategoryIndicators']['errors'])
        .to(eq(['Editing rubric category is not allowed.']))
    end
  end
end
