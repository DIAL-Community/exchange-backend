# frozen_string_literal: true

require 'kramdown'
require 'kramdown-parser-gfm'
require 'modules/slugger'
require 'nokogiri'

include Modules::Slugger

namespace :markdown_sync do
  desc 'Sync use case github structure.'
  task use_case_definition: :environment do
    UseCase.all.each do |use_case|
      next if use_case.markdown_url.nil?

      data = URI.parse(use_case.markdown_url).read

      html_md = Kramdown::Document.new(data, input: 'GFM').to_html
      html_fragment = Nokogiri::HTML.fragment(html_md)
      puts "Processing: #{html_fragment.at_css('h1').content}"

      successful_operation = false
      ActiveRecord::Base.transaction do
        use_case_description = UseCaseDescription.find_by(use_case:, locale: 'en')
        use_case_description = UseCaseDescription.new if use_case_description.nil?
        use_case_description.description = find_use_case_description(html_fragment)&.strip
        use_case_description.use_case = use_case
        use_case_description.locale = 'en'
        use_case_description.save!

        update_sdg_targets(use_case, html_fragment)
        update_use_case_steps(use_case, html_fragment)

        use_case.save!
        successful_operation = true
      end

      if successful_operation
        puts "Use case '#{use_case.name}' data saved."
      end
    end
  end

  def find_use_case_description(root)
    description = ''
    end_description = false
    start_description = false

    current_node = root.at_css(':first-child')
    until end_description
      if !start_description && current_node.name == 'table'
        start_description = true
      end

      if start_description && !end_description
        description += current_node.to_html
      end

      current_node = current_node.next
      if start_description && current_node.name == 'h2'
        end_description = true
      end
    end

    start_stakeholders = false
    end_stakeholders = false
    until end_stakeholders
      if !start_stakeholders && current_node.name == 'h2'
        start_stakeholders = true
      end

      if start_description && !end_stakeholders
        description += current_node.to_html
      end

      current_node = current_node.next
      if start_stakeholders && current_node.name == 'h2'
        end_stakeholders = true
      end
    end

    description
  end

  def update_sdg_targets(use_case, root)
    current_node = root.at_css(':first-child')
    node_found = false
    until node_found || current_node.nil?
      current_node = current_node.next
      if current_node.name == 'h2' && current_node.text.start_with?('SDG Targets')
        node_found = true
      end
    end

    use_case_sdg_targets = []

    target_number_format = /(\d+\.\d+)/
    sdg_target_nodes = current_node.at_css('+ ul').css('li')
    sdg_target_nodes.each do |sdg_target_node|
      matches = sdg_target_node.content.match(target_number_format)
      target_number, _others = matches
      sdg_target = SdgTarget.find_by(target_number: target_number.to_s)
      puts "  '#{target_number}' returning #{sdg_target.nil? ? 'no record' : 'a record'}."

      use_case_sdg_targets << sdg_target unless sdg_target.nil?
    end
    use_case.sdg_targets = use_case_sdg_targets
  end

  def update_use_case_steps(use_case, root)
    use_case_steps = []

    step_header_format = /\d+ - \D+/

    step_roots = root.css('h3')
    step_roots.each do |step_root|
      current_node = step_root
      next unless current_node.content.match(step_header_format)

      puts "------------------------------------"
      puts "Processing step: #{current_node.content.gsub(/\\&/, '&')}"
      step_number, step_name = current_node.content.split('-')

      # Cleanup spaces around
      step_name = step_name.strip.gsub(/\\&/, '&')
      step_number = step_number.strip.to_i

      use_case_step = UseCaseStep.find_by(
        name: step_name,
        use_case_id: use_case.id
      )
      if use_case_step.nil?
        use_case_step = UseCaseStep.new(
          name: step_name,
          slug: slug_em(step_name),
          use_case:
        )

        # Check if we need to add _dup to the slug.
        first_duplicate = UseCaseStep.slug_simple_starts_with(use_case_step.slug)
                                     .order(slug: :desc)
                                     .first
        unless first_duplicate.nil?
          use_case_step.slug += generate_offset(first_duplicate)
        end
      end

      use_case_step.step_number = step_number

      step_description = ''
      end_description = false
      start_description = false

      until end_description
        if !start_description && current_node.name == 'p'
          start_description = true
        end

        if start_description && !end_description
          step_description += current_node.to_html
        end

        current_node = current_node.next
        next unless start_description && !current_node.children.empty?

        first_child, others = current_node.children
        if others.nil? && first_child.name == 'strong' && first_child.text.start_with?('Workflows')
          end_description = true
        end
      end

      update_step_workflows(use_case_step, step_root)
      update_step_example_implementation(use_case_step, step_root)
      update_step_building_blocks(use_case_step, step_root)
      use_case_step.save!

      use_case_step_description = UseCaseStepDescription.find_by(use_case_step: use_case, locale: 'en')
      use_case_step_description = UseCaseStepDescription.new if use_case_step_description.nil?
      use_case_step_description.description = step_description.strip
      use_case_step_description.use_case_step_id = use_case_step.id
      use_case_step_description.locale = 'en'
      use_case_step_description.save!

      use_case_steps << use_case_step
    end

    use_case.use_case_steps = use_case_steps
  end

  def update_step_workflows(use_case_step, step_root)
    current_node = find_strong_node(step_root, 'Workflow')
    return if current_node.nil?

    puts "Processing node: #{current_node.content}"

    use_case_step_workflows = []
    workflow_nodes = current_node.at_css('+ ul').css('li')
    workflow_nodes.each do |workflow_node|
      workflow_names = workflow_node.at_css('strong').content.strip.split('/')
      workflow_names.each do |workflow_name|
        workflow = Workflow.find_by(name: workflow_name)
        puts "  '#{workflow_name}' returning #{workflow.nil? ? 'no record' : 'a record'}."

        use_case_step_workflows << workflow unless workflow.nil?
      end
    end
    use_case_step.workflows = use_case_step_workflows
  end

  def update_step_example_implementation(use_case_step, step_root)
    current_node = find_strong_node(step_root, 'Example Implementation')
    return if current_node.nil?

    puts "Processing node: #{current_node.content}"

    example_implementation_info_node = current_node.at_css(' + p')
    puts "Example implementation: #{example_implementation_info_node.content}."
    if example_implementation_info_node.name == 'p'
      use_case_step.example_implementation = example_implementation_info_node.content
    end
  end

  def update_step_building_blocks(use_case_step, step_root)
    current_node = find_strong_node(step_root, 'Building Block')
    return if current_node.nil?

    puts "Processing node: #{current_node.content}"

    end_step = false
    use_case_step_building_blocks = []
    until end_step || current_node.nil?
      current_node = current_node.next
      next if current_node.content.blank?

      if current_node.name == 'h2' || current_node.name == 'h3'
        end_step = true
        next
      end

      building_block_name = current_node.content.gsub(/\*/, '')
      building_block = BuildingBlock.find_by(name: building_block_name)
      puts "  '#{building_block_name}' returning #{building_block.nil? ? 'no record' : 'a record'}."

      use_case_step_building_blocks << building_block unless building_block.nil?
    end
    use_case_step.building_blocks = use_case_step_building_blocks
  end

  def find_strong_node(starting_node, node_text)
    node_found = false
    current_node = starting_node
    until node_found || current_node.nil?
      current_node = current_node.next
      next if current_node.nil? || current_node.children.empty?

      first_child, others = current_node.children
      next unless others.nil?

      if first_child.name == 'strong' && first_child.text.start_with?(node_text)
        node_found = true
      end
    end
    current_node
  end
end
