# frozen_string_literal: true

require 'modules/slugger'

resource_type_names = [
  "Article",
  "Blog",
  "Book",
  "Case Study",
  "Essay",
  "Expert Comment",
  "Explainer",
  "Government Document",
  "Guidance",
  "National Website",
  "Playbook",
  "Report",
  "Spotlight",
  "Unspecified Type",
  "White Paper",
  "Working Papers"
]

resource_type_mapping = {
  'ui.resource.type.blog' => 'Blog',
  'ui.resource.type.book' => 'Book',
  'ui.resource.type.caseStudy' => 'Case Study',
  'ui.resource.type.expertComment' => 'Expert Comment',
  'ui.resource.type.expertcomment' => 'Expert Comment',
  'ui.resource.type.report' => 'Report',
  'ui.resource.type.spotlight' => 'Spotlight',
  'ui.resource.type.whitepaper' => 'White Paper',
  'ui.resource.type.workingPaper' => 'Working Papers'
}

resource_type_names.each do |resource_type_name|
  resource_type_slug = reslug_em(resource_type_name)
  resource_type = ResourceType.find_by(name: resource_type_name)
  resource_type = ResourceType.find_by(slug: resource_type_slug) if resource_type.nil?

  if resource_type.nil?
    resource_type = ResourceType.new(name: resource_type_name, slug: resource_type_slug)
    resource_type.description = "Simple description for: #{resource_type_name}."
    resource_type.locale = 'en'
  end

  if resource_type.save
    puts "Saving resource type: #{resource_type.name}."
  end
end

Resource.all.each do |resource|
  existing_resource_type = resource.resource_type
  puts "Processing: #{resource.name}:"

  # Unable to resolve resource type even when we have value for the existing resource type name
  unless existing_resource_type.nil?
    resource_type = ResourceType.find_by(name: existing_resource_type.strip)
    if resource_type.nil?
      existing_resource_type = resource_type_mapping[existing_resource_type]
      resource_type = ResourceType.find_by(name: existing_resource_type.strip)
    end
  end

  # Default to 'Unspecified Type' otherwise.
  resource_type = ResourceType.find_by(name: 'Unspecified Type') if resource_type.nil?
  resource.resource_type = resource_type.name

  if resource.save
    puts "  Resource '#{resource.name}' from '#{existing_resource_type}' to '#{resource.resource_type}' updated."
  end
end
