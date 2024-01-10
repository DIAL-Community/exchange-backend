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
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: true
    field :maturity, String, null: false
    field :markdown_url, String, null: true

    field :gov_stack_entity, Boolean, null: false

    field :use_case_descriptions, [Types::UseCaseDescriptionType], null: true
    field :use_case_description, Types::UseCaseDescriptionType, null: false,
      method: :use_case_description_localized

    field :parsed_description, String, null: true
    def parsed_description
      return if object.use_case_description_localized.nil?

      object_description = object.use_case_description_localized.description
      first_paragraph = Nokogiri::HTML.fragment(object_description).at('p')
      first_paragraph.nil? ? object_description : first_paragraph.inner_html
    end

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
    field :tags, GraphQL::Types::JSON, null: true
    field :sector, Types::SectorType, null: false
  end
end
