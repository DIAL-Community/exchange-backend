# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :opportunity do
    origin { FactoryBot.create(:origin) }
    sequence(:id)
    sequence(:name) { |name| "Opportunity: #{name}" }
    sequence(:slug) { |slug| "slug_#{slug}" }
    sequence(:web_address)
  end
end
