# frozen_string_literal: true

module Paginated
  class PaginatedResources < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    argument :show_in_wizard, Boolean, required: false, default_value: false
    argument :show_in_exchange, Boolean, required: false, default_value: false

    argument :resource_type, String, required: false, default_value: ''
    argument :resource_topic, String, required: false, default_value: ''

    argument :compartmentalized, Boolean, required: true, default_value: false
    argument :featured_only, Boolean, required: false, default_value: false
    argument :featured_length, Integer, required: false, default_value: 3
    argument :spotlight_only, Boolean, required: false, default_value: false
    argument :spotlight_length, Integer, required: false, default_value: 1

    argument :offset_attributes, Attributes::OffsetAttributes, required: true

    type [Types::ResourceType], null: false

    def resolve(
      search:, show_in_wizard:, show_in_exchange:, offset_attributes:, compartmentalized:,
      featured_only:, featured_length:, spotlight_only:, spotlight_length:,
      resource_type:, resource_topic:
    )
      # Sort resources by:
      # - spotlight
      # - featured
      # - published_date
      #
      # Offset calculation steps:
      # - Find spotlight resource
      # - If spotlight resource found, offset = offset + 1
      # - Return the next 3 resources
      #   - The 3 will be either all 3 featured resources or some

      resources = Resource
                  .order(spotlight: :desc)
                  .order(featured: :desc)
                  .order(published_date: :desc)

      current_offset = 0

      if compartmentalized
        spotlight_resources = resources.where(spotlight: true)
        if spotlight_only
          return spotlight_resources.limit(spotlight_length).offset(current_offset)
        end
        current_offset += spotlight_length unless spotlight_resources.empty?

        if featured_only
          return resources.limit(featured_length).offset(current_offset)
        end
        current_offset += featured_length

        unless search.blank?
          resources = resources.name_contains(search)
        end
      end

      unless resource_type.blank?
        resources = resources.where('LOWER(resource_type) like LOWER(?)', "%#{resource_type}%")
      end

      unless resource_topic.blank?
        resources = resources.where('LOWER(resource_topic) like LOWER(?)', "%#{resource_topic}%")
      end

      resources = resources.where(show_in_exchange: true) if show_in_exchange
      resources = resources.where(show_in_wizard: true) if show_in_wizard

      offset_params = offset_attributes.to_h
      resources.limit(offset_params[:limit]).offset(current_offset + offset_params[:offset])
    end
  end
end
