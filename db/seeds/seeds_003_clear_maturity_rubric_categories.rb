# frozen_string_literal: true

rubric_categories = RubricCategory.where("slug in (" \
"'financial_sustainability', 'licensing','product_design','compliance','utility_and_impact'," \
"'product_quality','community_health','dependency_and_risk','knowledge_management','governance')")
puts "Rubric categories length: #{rubric_categories.length}."
rubric_categories.each do |rubric_category|
  puts "Removing rubric category: #{rubric_category.name}."

  category_indicators = CategoryIndicator.where(rubric_category_id: rubric_category.id)
  category_indicators.each do |category_indicator|
    puts "Category indicator: #{category_indicator.name} deleted." if category_indicator.destroy
  end

  rubric_category_descriptions = RubricCategoryDescription.where(rubric_category_id: rubric_category.id)
  rubric_category_descriptions.each do |rubric_category_description|
    puts "Category description deleted." if rubric_category_description.destroy
  end

  puts "Rubric category: #{rubric_category.name} deleted." if rubric_category.destroy
  puts "--"
end
