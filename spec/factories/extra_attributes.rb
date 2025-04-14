# frozen_string_literal: true

FactoryBot.define do
  factory :extra_attribute do
    name { "MyString" }
    title { "MyText" }
    title_fallback { "MyString" }
    description { "MyString" }
    description_fallback { "MyString" }
    required { false }
    multiple { false }
    type { "" }
    options { "MyString" }
    elements { "MyString" }
  end
end
