# frozen_string_literal: true

module Queries
  class SoftwareFeaturesQuery < Queries::BaseQuery
    argument :category_slug, String, required: true
    type [Types::SoftwareFeatureType], null: false

    def resolve(search:)
      features = SoftwareFeature.where(software_category: category_slug).order(:name)
      features
    end
  end

  class SoftwareFeatureQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::SoftwareFeatureType, null: true

    def resolve(slug:)
      SoftwareFeature.find_by(slug:)
    end
  end
end
