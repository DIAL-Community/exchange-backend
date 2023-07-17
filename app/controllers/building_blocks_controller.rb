# frozen_string_literal: true

class BuildingBlocksController < ApplicationController
  include ApiFilterConcern

  def unique_search
    record = BuildingBlock.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(BuildingBlock.serialization_options
                                             .merge({
                                               item_path: request.original_url,
                                               include_relationships: true
                                             })))
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
      results['next_page'] = CGI.escape(uri.to_s)
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = CGI.escape(uri.to_s)
    end

    results['results'] = building_blocks.paginate(page: current_page, per_page: page_size)
                                        .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-building-blocks')
      end
      format.json do
        render(json: results.to_json(BuildingBlock.serialization_options
                                                  .merge({
                                                    collection_path: uri.to_s,
                                                    include_relationships: true
                                                  })))
      end
    end
  end

  def complex_search
    page_size = 20
    building_blocks = BuildingBlock

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    if params[:search].present?
      name_bbs = building_blocks.name_contains(params[:search])
      desc_bbs = building_blocks.joins(:building_block_descriptions)
                                .where('LOWER(building_block_descriptions.description) like LOWER(?)',
                                       "%#{params[:search]}%")
      building_blocks = building_blocks.where(id: (name_bbs + desc_bbs).uniq)
    end

    sdg_use_case_slugs = []
    sdg_use_case_slugs = use_cases_from_sdg_slugs(params[:sdgs]) if valid_array_parameter(params[:sdgs])
    if sdg_use_case_slugs.nil? && valid_array_parameter(params[:sustainable_development_goals])
      sdg_use_case_slugs = use_cases_from_sdg_slugs(params[:sustainable_development_goals])
    end

    use_case_slugs = sdg_use_case_slugs
    if valid_array_parameter(params[:use_cases])
      if use_case_slugs.nil? || use_case_slugs.empty?
        use_case_slugs = params[:use_cases]
      else
        use_case_slugs &= params[:use_cases]
      end
    end
    use_case_workflow_slugs = workflows_from_use_case_slugs(use_case_slugs)

    workflow_slugs = use_case_workflow_slugs
    if valid_array_parameter(params[:workflows])
      if workflow_slugs.nil? || workflow_slugs.empty?
        workflow_slugs = params[:workflows]
      else
        workflow_slugs &= params[:workflows]
      end
    end
    workflow_building_block_slugs = building_blocks_from_workflow_slugs(workflow_slugs)

    building_block_slugs = workflow_building_block_slugs
    if valid_array_parameter(params[:building_blocks])
      if building_block_slugs.nil? || building_block_slugs.empty?
        building_block_slugs = params[:building_blocks]
      else
        building_block_slugs &= params[:building_blocks]
      end
    end

    building_block_product_slugs = []
    if valid_array_parameter(params[:products])
      building_block_product_slugs = building_blocks_from_product_slugs(params[:products])
    end

    if building_block_slugs.nil? || building_block_slugs.empty?
      building_block_slugs = building_block_product_slugs
    elsif !building_block_product_slugs.nil? && !building_block_product_slugs.empty?
      building_block_slugs &= building_block_product_slugs
    end

    building_block_slugs = building_block_slugs.reject { |x| x.nil? || x.empty? }
    building_blocks = building_blocks.where(slug: building_block_slugs) \
      unless building_block_slugs.nil? || building_block_slugs.empty?

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
      results['next_page'] = CGI.escape(uri.to_s)
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = CGI.escape(uri.to_s)
    end

    results['results'] = building_blocks.paginate(page: current_page, per_page: page_size)
                                        .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-building-blocks')
      end
      format.json do
        render(json: results.to_json(BuildingBlock.serialization_options
                                                  .merge({
                                                    collection_path: uri.to_s,
                                                    include_relationships: true
                                                  })))
      end
    end
  end
end
