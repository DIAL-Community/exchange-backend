# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :dataset do
    origins { [FactoryBot.create(:origin)] }
    sequence(:id)
    sequence(:name) { |name| "Dataset: #{name}" }
    sequence(:slug) { |slug| "slug_#{slug}" }
    sequence(:website)
    sequence(:dataset_type)
  end
end
