# frozen_string_literal: true

module Types
  class UseCaseDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :use_case_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class UseCaseHeaderType < Types::BaseObject
    field :id, ID, null: false
    field :use_case_id, Integer, null: true
    field :locale, String, null: false
    field :header, String, null: false
  end

  class UseCaseType < Types::BaseObject
    include ActionView::Helpers::SanitizeHelper

    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: false
    field :maturity, String, null: false
    field :markdown_url, String, null: true

    field :gov_stack_entity, Boolean, null: false

    field :use_case_descriptions, [Types::UseCaseDescriptionType], null: true
    field :use_case_description, Types::UseCaseDescriptionType, null: false,
      method: :use_case_description_localized

    # Description without HTML tags
    field :parsed_description, String, null: true
    def parsed_description
      return if object.use_case_description_localized.nil?

      object_description = object.use_case_description_localized.description
      strip_links(object_description)
    end

    # Description without the initial table tag at the top
    field :sanitized_description, String, null: false
    def sanitized_description
      use_case_description = object.use_case_description_localized
      return '' if use_case_description.nil?

      html_fragment = Nokogiri::HTML.fragment(use_case_description.description)
      html_fragment.search('.//table').remove

      paragraph_nodes = html_fragment.search('p')
      paragraph_nodes.each { |node| node.remove_attribute('style') }

      anchor_nodes = html_fragment.search('a')
      anchor_nodes.each { |node| node.replace(node.content) }

      html_fragment
    end

    field :use_case_steps, [Types::UseCaseStepType], null: true
    field :use_case_headers, [Types::UseCaseHeaderType], null: true

    field :sdg_targets, [Types::SustainableDevelopmentGoalTargetType], null: false
    def sdg_targets
      object.sdg_targets&.order(:sdg_number)&.order(:target_number)
    end

    field :building_blocks, [Types::BuildingBlockType], null: true
    def building_blocks
      use_case_building_blocks = []
      if !object.use_case_steps.nil? && !object.use_case_steps.empty?
        object.use_case_steps.each do |use_case_step|
          use_case_building_blocks |= use_case_step.building_blocks
        end
      end
      use_case_building_blocks.sort_by(&:display_order)
    end

    field :workflows, [Types::WorkflowType], null: true
    def workflows
      use_case_workflows = []
      if !object.use_case_steps.nil? && !object.use_case_steps.empty?
        object.use_case_steps.each do |use_case_step|
          use_case_workflows |= use_case_step.workflows
        end
      end
      use_case_workflows.sort_by { |w| w.name.downcase }
    end

    field :tags, GraphQL::Types::JSON, null: true
    field :sector, Types::SectorType, null: true
    def sector
      sector_slug = object.sector.slug
      matching_sector = Sector.find_by(slug: sector_slug, locale: I18n.locale)
      if matching_sector.nil?
        matching_sector = Sector.find_by(slug: sector_slug, locale: 'en')
      end
      matching_sector
    end
  end
end
