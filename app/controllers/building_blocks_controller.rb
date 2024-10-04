# frozen_string_literal: true

class BuildingBlocksController < ApplicationController
  include ApiFilterConcern

  def govstack_search
    page_size = 20
    building_blocks = BuildingBlock.where(gov_stack_entity: true)

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    building_blocks = building_blocks.name_contains(params[:search]) if params[:search].present?

    results = {
      url: request.original_url,
      count: building_blocks.count,
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if building_blocks.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = building_blocks.paginate(page: current_page, per_page: page_size)
                                        .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-building-blocks')
      end
      format.json do
        render(json: results.to_json(
          BuildingBlock.serialization_options.merge({
            collection_path: uri.to_s,
            include_relationships: true,
            govstack_path: true
          })
        ))
      end
    end
  end

  def govstack_unique_search
    record = BuildingBlock.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(
      BuildingBlock.serialization_options.merge({
        item_path: request.original_url,
        include_relationships: true,
        govstack_path: true
      })
    ))
  end

  def unique_search
    record = BuildingBlock.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(
      BuildingBlock.serialization_options.merge({
        item_path: request.original_url,
        include_relationships: true
      })
    ))
  end

  def simple_search
    page_size = 20
    building_blocks = BuildingBlock

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    building_blocks = building_blocks.name_contains(params[:search]) if params[:search].present?

    results = {
      url: request.original_url,
      count: building_blocks.count,
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if building_blocks.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = building_blocks.paginate(page: current_page, per_page: page_size)
                                        .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-building-blocks')
      end
      format.json do
        render(json: results.to_json(
          BuildingBlock.serialization_options.merge({
            collection_path: uri.to_s,
            include_relationships: true
          })
        ))
      end
    end
  end

  def complex_search
    page_size = 20
    building_blocks = BuildingBlock.distinct

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    search = params[:search]
    if search.present?
      name_filter = building_blocks.name_contains(search)
      desc_filter = building_blocks.joins(:building_block_descriptions)
                                   .where('LOWER(building_block_descriptions.description) like LOWER(?)', "%#{search}%")
      building_blocks = building_blocks.where(id: (name_filter + desc_filter).uniq)
    end

    filtered = false

    sdg_use_case_ids = []
    filtered_sdgs = params[:sdgs].reject { |x| x.nil? || x.empty? }
    unless filtered_sdgs.empty?
      filtered = true
      sdg_numbers = SustainableDevelopmentGoal.where(id: filtered_sdgs)
                                              .select(:number)
      sdg_use_cases = UseCase.joins(:sdg_targets)
                             .where(sdg_targets: { sdg_number: sdg_numbers })
      sdg_use_case_ids += sdg_use_cases.ids unless sdg_use_cases.empty?
    end

    use_case_ids = []
    filtered_use_cases = params[:use_cases].reject { |x| x.nil? || x.empty? }
    unless filtered_use_cases.empty?
      filtered = true
      use_case_ids += UseCase.where(slug: filtered_use_cases).ids
    end

    workflow_slugs = []
    filtered_use_cases = use_case_ids + sdg_use_case_ids
    unless filtered_use_cases.empty?
      filtered = true
      use_case_workflows = Workflow.joins(:use_case_steps)
                                   .where(use_case_steps: { use_case_id: filtered_use_cases })
      workflow_slugs += use_case_workflows.map(&:slug) unless use_case_workflows.empty?
    end

    filtered_workflows = workflow_slugs + params[:workflows].reject { |x| x.nil? || x.empty? }
    filtered = true unless params[:workflows].empty?

    if filtered && filtered_workflows.empty?
      building_blocks = BuildingBlock.none
    else
      unless filtered_workflows.empty?
        building_blocks = building_blocks.joins(:workflows)
                                         .where(workflows: { slug: filtered_workflows })
      end

      if params[:show_mature].present? && params[:show_mature].to_s.downcase == 'true'
        published_building_block = BuildingBlock.entity_status_types[:PUBLISHED]
        building_blocks = building_blocks.where(maturity: published_building_block)
      end

      if params[:show_gov_stack_only].present? && params[:show_gov_stack_only].to_s.downcase == 'true'
        building_blocks = building_blocks.where(gov_stack_entity: true)
      end

      filterd_category_types = params[:category_types].reject { |x| x.nil? || x.empty? }
      unless filterd_category_types.empty?
        building_blocks = building_blocks.where(category: filterd_category_types)
      end
    end

    if params[:page_size].present?
      if params[:page_size].to_i.positive?
        page_size = params[:page_size].to_i
      elsif params[:page_size].to_i.negative?
        page_size = building_blocks.count
      end
    end

    results = {
      url: request.original_url,
      count: building_blocks.count,
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if building_blocks.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = building_blocks.paginate(page: current_page, per_page: page_size)
                                        .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-building-blocks')
      end
      format.json do
        render(json: results.to_json(
          BuildingBlock.serialization_options.merge({
            collection_path: uri.to_s,
            include_relationships: true
          })
        ))
      end
    end
  end
end
