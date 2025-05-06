# frozen_string_literal: true

require 'modules/slugger'
include Modules::Slugger

namespace :extra_attributes do
  task migrate_definitions: :environment do
    existing_definitions = YAML.load_file('./data/yaml/candidate-extra-attributes.yml')
    existing_definitions.each do |existing_definition|
      extra_attribute_definition = ExtraAttributeDefinition.find_by(name: existing_definition['name'])
      if extra_attribute_definition.nil?
        extra_attribute_definition = ExtraAttributeDefinition.new(name: existing_definition['name'])
      end

      extra_attribute_definition.title = existing_definition['title']
      extra_attribute_definition.slug = reslug_em(existing_definition['title'])
      extra_attribute_definition.description = existing_definition['description']
      case existing_definition['type']
      when 'composite'
        extra_attribute_definition.attribute_type = 'ui.extraAttributeDefinition.attributeType.composite'
      when 'select'
        extra_attribute_definition.attribute_type = 'ui.extraAttributeDefinition.attributeType.select'
        case existing_definition['options']
        when 'read(building-blocks)'
          extra_attribute_definition['choices'] = BuildingBlock.all.order(:name).pluck(:name)
        when 'read(sectors)'
          extra_attribute_definition['choices'] = Sector.all.order(:name).pluck(:name)
        when 'read(sustainable-development-goals)'
          extra_attribute_definition['choices'] = SustainableDevelopmentGoal.all.order(:number).pluck(:name)
        when 'read(tags)'
          extra_attribute_definition['choices'] = Tag.all.order(:name).pluck(:name)
        else
          extra_attribute_definition['choices'] = existing_definition['options']
        end
      when 'text'
        extra_attribute_definition.attribute_type = 'ui.extraAttributeDefinition.attributeType.text'
      when 'url'
        extra_attribute_definition.attribute_type = 'ui.extraAttributeDefinition.attributeType.url'
      else
        # Default it to text field.
        extra_attribute_definition.attribute_type = 'ui.extraAttributeDefinition.attributeType.text'
      end
      extra_attribute_definition.attribute_required = existing_definition['required']
      extra_attribute_definition.multiple_choice = existing_definition['multiple']
      if extra_attribute_definition.save
        puts "Extra attribute definition '#{extra_attribute_definition.name}' saved successfully."
      end
    end

    existing_definitions.each do |existing_definition|
      next unless existing_definition['type'] == 'composite'

      extra_attribute_definition = ExtraAttributeDefinition.find_by(name: existing_definition['name'])
      existing_definition['attributes'].each do |attribute|
        child_extra_attribute_definition = ExtraAttributeDefinition.find_by(name: attribute['name'])
        unless child_extra_attribute_definition.nil?
          extra_attribute_definition.child_extra_attribute_names << child_extra_attribute_definition.name
        end
      end

      if extra_attribute_definition.save
        puts "Child extra attribute definition for '#{extra_attribute_definition.name}' saved successfully."
      end
    end
  end
end
