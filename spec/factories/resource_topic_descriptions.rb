# frozen_string_literal: true

FactoryBot.define do
  factory :resource_topic_description do
    locale { "en" }
    description { "Some example of description." }
  end
end
