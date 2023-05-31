# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :resource do
    sequence(:slug)
    sequence(:name)
    sequence(:phase)
  end
end
