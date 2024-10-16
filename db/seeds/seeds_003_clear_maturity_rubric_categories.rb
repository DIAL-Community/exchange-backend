# frozen_string_literal: true

rubric_categories = RubricCategory.where("slug SIMILAR TO '(" \
"financial-sustainability|licensing|product-design|compliance|utility-and-impact|" \
"product-quality|community-health|dependency-and-risk|knowledge-management|governance|" \
"repository-info|consensus-building|independence|licenses-and-copyright|" \
"software-code|software-quality|software-releases)%'")
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
  puts "-------"
end
