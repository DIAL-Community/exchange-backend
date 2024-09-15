# frozen_string_literal: true

class WorkflowsController < ApplicationController
  include ApiFilterConcern

  def unique_search
    record = Workflow.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(Workflow.serialization_options
                                        .merge({
                                          item_path: request.original_url,
                                          include_relationships: true
                                        })))
  end

  def simple_search
    page_size = 20
    workflows = Workflow

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    workflows = workflows.name_contains(params[:search]) if params[:search].present?

    results = {
      url: request.original_url,
      count: workflows.count,
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if workflows.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = workflows.paginate(page: current_page, per_page: page_size)
                                  .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-workflows')
      end
      format.json do
        render(json: results.to_json(Workflow.serialization_options
                                             .merge({
                                               collection_path: uri.to_s,
                                               include_relationships: true
                                             })))
      end
    end
  end

  def complex_search
    page_size = 20
    workflows = Workflow.order(:name)

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    search = params[:search]
    unless search.blank?
      name_filter = Workflow.name_contains(search).distinct
      description_filter = Workflow.joins(:workflow_descriptions)
                                   .where('LOWER(workflow_descriptions.description) like LOWER(?)', "%#{search}%")
      workflows = workflows.where(id: (name_filter.ids + description_filter.ids).uniq)
    end

    sdg_use_case_ids = []
    filtered_sdgs = params[:sdgs].reject { |x| x.nil? || x.empty? }
    unless filtered_sdgs.empty?
      sdg_numbers = SustainableDevelopmentGoal.where(slug: filtered_sdgs)
                                              .select(:number)
      sdg_use_cases = UseCase.joins(:sdg_targets)
                             .where(sdg_targets: { sdg_number: sdg_numbers })
      sdg_use_case_ids += sdg_use_cases.ids unless sdg_use_cases.empty?
    end

    use_case_ids = []
    filtered_use_cases = params[:use_cases].reject { |x| x.nil? || x.empty? }
    unless filtered_use_cases.empty?
      use_case_ids += UseCase.where(slug: filtered_use_cases).ids
    end

    filtered_use_cases = sdg_use_case_ids + use_case_ids
    unless filtered_use_cases.empty?
      use_case_filter = Workflow.joins(:use_case_steps)
                                .where(use_case_steps: { use_case_id: filtered_use_cases })
      workflows = workflows.where(id: use_case_filter.uniq)
    end

    if params[:page_size].present?
      if params[:page_size].to_i.positive?
        page_size = params[:page_size].to_i
      elsif params[:page_size].to_i.negative?
        page_size = workflows.count
      end
    end

    results = {
      url: request.original_url,
      count: workflows.count,
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if workflows.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = workflows.paginate(page: current_page, per_page: page_size)
                                  .order(:slug)

    uri.fragment = uri.query = nil

    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-workflows')
      end
      format.json do
        render(json: results.to_json(Workflow.serialization_options
                                             .merge({
                                               collection_path: uri.to_s,
                                               include_relationships: true
                                             })))
      end
    end
  end
end
