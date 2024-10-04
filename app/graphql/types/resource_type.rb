# frozen_string_literal: true

module Types
  class AuthorType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :email, String, null: true
    field :picture, String, null: false
  end

  class ResourceTypeType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :description, String, null: true
    field :locale, String, null: false
  end

  class ResourceType < Types::BaseObject
    include ActionView::Helpers::SanitizeHelper

    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :phase, String, null: false

    field :image_file, String, null: false
    field :image_url, String, null: true

    field :published_date, GraphQL::Types::ISO8601Date, null: true

    field :description, String, null: true
    field :parsed_description, String, null: true
    def parsed_description
      return if object.description.nil?

      object_description = object.description
      strip_links(object_description)
    end

    field :show_in_exchange, Boolean, null: false
    field :show_in_wizard, Boolean, null: false

    field :link_description, String, null: true
    field :resource_file, String, null: true
    field :resource_link, String, null: true

    field :resource_type, String, null: true
    field :resource_topics, [Types::ResourceTopicType], null: true
    def resource_topics
      resolved_resource_topics = []
      object.resource_topics.each do |resource_topic|
        resolved_resource_topic = ResourceTopic.find_by(name: resource_topic)
        resolved_resource_topics << resolved_resource_topic unless resolved_resource_topic.nil?
      end
      resolved_resource_topics
    end

    field :source, Types::OrganizationType, null: true
    def source
      Organization.find(object.organization_id) unless object.organization_id.nil?
    end

    field :tags, GraphQL::Types::JSON, null: false

    field :featured, Boolean, null: false

    field :submitted_by, Types::UserType, null: true
    def submitted_by
      return nil if context[:current_user].nil?
      object.submitted_by
    end

    field :building_blocks, [Types::BuildingBlockType], null: true
    def building_blocks
      object.resource_building_blocks.map(&:building_block)
    end

    field :building_blocks_mapping_status, String, method: :building_blocks_mapping_status

    field :use_cases, [Types::UseCaseType], null: false

    field :organizations, [Types::OrganizationType], null: false
    field :countries, [Types::CountryType], null: false, method: :countries_ordered
    field :products, [Types::ProductType], null: false, method: :products_ordered
    field :authors, [Types::AuthorType], null: false, method: :authors_ordered
  end
end
