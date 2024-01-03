# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :province do
    sequence(:slug)
    sequence(:name)
    sequence(:latitude)
    sequence(:longitude)
  end
end
