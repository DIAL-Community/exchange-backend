# frozen_string_literal: true

module Paginated
  class PaginationAttributeResource < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :show_in_exchange, Boolean, required: false, default_value: false
    argument :show_in_wizard, Boolean, required: false, default_value: false

    argument :resource_type, String, required: false, default_value: ''
    argument :resource_topic, String, required: false, default_value: ''

    argument :compartmentalized, Boolean, required: true, default_value: false
    argument :featured_length, Integer, required: false, default_value: 3
    argument :spotlight_length, Integer, required: false, default_value: 1

    type Attributes::PaginationAttributes, null: false

    def resolve(
      search:, show_in_exchange:, show_in_wizard:, compartmentalized:,
      featured_length:, spotlight_length:,
      resource_type:, resource_topic:
    )
      resources = Resource
                  .order(spotlight: :desc)
                  .order(featured: :desc)
                  .order(published_date: :desc)

      current_offset = 0
      if compartmentalized
        spotlight_resources = resources.where(spotlight: true)
        current_offset += spotlight_length unless spotlight_resources.empty?
        current_offset += featured_length
      end

      unless search.blank?
        resources = resources.name_contains(search)
      end

      unless resource_type.blank?
        resources = resources.where('LOWER(resource_type) like LOWER(?)', "%#{resource_type}%")
      end

      unless resource_topic.blank?
        resources = resources.where('LOWER(resource_topic) like LOWER(?)', "%#{resource_topic}%")
      end

      resources = resources.where(show_in_exchange: true) if show_in_exchange
      resources = resources.where(show_in_wizard: true) if show_in_wizard

      resource_count = resources.count - current_offset

      { total_count: resource_count <= 0 ? 0 : resource_count }
    end
  end
end
