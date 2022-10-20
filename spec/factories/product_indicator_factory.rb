# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :product_indicator do
    sequence(:id)
    sequence(:product_id)
    sequence(:category_indicator_id)
    sequence(:indicator_value)
  end
end
