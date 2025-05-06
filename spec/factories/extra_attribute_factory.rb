# frozen_string_literal: true

FactoryBot.define do
  factory :extra_attribute_definition do
    name { "extraAttributeDefinition" }
    title { "Extra Attribute Definition" }
    title_fallback { "Extra Attribute Definition" }
    description { "Extra attribute definition description." }
    description_fallback { "Extra attribute definition description." }
    required { false }
    multiple { false }
    type { "text" }
  end
end
