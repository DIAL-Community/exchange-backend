# frozen_string_literal: true

module Queries
  class CandidateProductQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CandidateProductType, null: true

    def resolve(slug:)
      candidate_product = CandidateProduct.find_by(slug:) if valid_slug?(slug)
      validate_access_to_instance(candidate_product || CandidateProduct.new)
      candidate_product
    end
  end

  class CandidateProductsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CandidateProductType], null: false

    def resolve(search:)
      validate_access_to_resource(CandidateProduct.new)
      candidate_products = CandidateProduct.order(:name)
      candidate_products = candidate_products.name_contains(search) unless search.blank?
      candidate_products
    end
  end

  class CandidateProductExtraAttributesQuery < Queries::BaseQuery
    type GraphQL::Types::JSON, null: false

    def resolve
      validate_access_to_resource(CandidateProduct.new)
      extra_attributes = YAML.load_file('data/yaml/candidate-extra-attributes.yml')
      extra_attributes.each_with_index do |extra_attribute, index|
        # Append index to each extra attribute
        extra_attribute['index'] = index

        # Sort options if they exist, otherwise update the 'read' attribute
        options = extra_attribute['options']
        next if options.nil?

        if extra_attribute['options'].is_a?(Array)
          extra_attribute['options'] = extra_attribute['options'].sort
        else
          case options
          when 'read(building-blocks)'
            extra_attribute['options'] = BuildingBlock.all.order(:name).pluck(:name)
          when 'read(sectors)'
            extra_attribute['options'] = Sector.all.order(:name).pluck(:name)
          when 'read(sustainable-development-goals)'
            extra_attribute['options'] = SustainableDevelopmentGoal.all.order(:number).pluck(:name)
          when 'read(tags)'
            extra_attribute['options'] = Tag.all.order(:name).pluck(:name)
          end
        end
      end
      extra_attributes
    end
  end
end
