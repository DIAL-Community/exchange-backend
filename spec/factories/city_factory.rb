# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :city do
    sequence(:slug)
    sequence(:name)
    sequence(:latitude)
    sequence(:longitude)
  end
end
