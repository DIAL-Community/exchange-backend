# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :candidate_dataset do
    sequence(:name)
    sequence(:slug)
    sequence(:website)
    sequence(:visualization_url)
    sequence(:dataset_type)
    sequence(:submitter_email)
    sequence(:description)
  end
end
