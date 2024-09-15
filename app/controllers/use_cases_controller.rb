# frozen_string_literal: true

class UseCasesController < ApplicationController
  include ApiFilterConcern

  def govstack_search
    page_size = 20
    use_cases = UseCase.where(gov_stack_entity: true)

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    use_cases = use_cases.name_contains(params[:search]) if params[:search].present?

    if params[:page_size].present?
      if params[:page_size].to_i.positive?
        page_size = params[:page_size].to_i
      elsif params[:page_size].to_i.negative?
        page_size = use_cases.count
      end
    end

    results = {
      url: request.original_url,
      count: use_cases.count,
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if use_cases.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = use_cases.paginate(page: current_page, per_page: page_size)
                                  .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-use-cases')
      end
      format.json do
        render(json: results.to_json(
          UseCase.serialization_options.merge({
            collection_path: uri.to_s,
            include_relationships: true,
            govstack_path: true
          })
        ))
      end
    end
  end

  def govstack_unique_search
    record = UseCase.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(
      UseCase.serialization_options.merge({
        item_path: request.original_url,
        include_relationships: true,
        govstack_path: true
      })
    ))
  end

  def unique_search
    record = UseCase.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(
      UseCase.serialization_options.merge({
        item_path: request.original_url,
        include_relationships: true
      })
    ))
  end

  def simple_search
    page_size = 20
    use_cases = UseCase

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    use_cases = use_cases.name_contains(params[:search]) if params[:search].present?

    if params[:page_size].present?
      if params[:page_size].to_i.positive?
        page_size = params[:page_size].to_i
      elsif params[:page_size].to_i.negative?
        page_size = use_cases.count
      end
    end

    results = {
      url: request.original_url,
      count: use_cases.count,
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if use_cases.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = use_cases.paginate(page: current_page, per_page: page_size)
                                  .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-use-cases')
      end
      format.json do
        render(json: results.to_json(
          UseCase.serialization_options.merge({
            collection_path: uri.to_s,
            include_relationships: true
          })
        ))
      end
    end
  end

  def complex_search
    page_size = 20
    use_cases = UseCase.order(:name).distinct

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    puts "Params: #{params.inspect}"

    if !params[:show_beta].present? || params[:show_beta].to_s == 'false'
      use_cases = use_cases.where(maturity: UseCase.entity_status_types[:PUBLISHED])
    end

    if params[:show_gov_stack_only].present? && params[:show_gov_stack_only].to_s == 'true'
      use_cases = use_cases.where(gov_stack_entity: true)
    end

    unless params[:search].blank?
      name_filter = use_cases.name_contains(params[:search])
      desc_filter = use_cases.left_joins(:use_case_descriptions)
                             .where('LOWER(use_case_descriptions.description) like LOWER(?)', "%#{params[:search]}%")
      use_cases = use_cases.where(id: (name_filter + desc_filter).uniq)
    end

    filtered_sdgs = params[:sdgs].reject { |x| x.nil? || x.empty? }
    unless filtered_sdgs.empty?
      sdg_numbers = SustainableDevelopmentGoal.where(slug: filtered_sdgs)
                                              .select(:number)
      use_cases = use_cases.left_joins(:sdg_targets)
                           .where(sdg_targets: { sdg_number: sdg_numbers })
    end

    if params[:page_size].present?
      if params[:page_size].to_i.positive?
        page_size = params[:page_size].to_i
      elsif params[:page_size].to_i.negative?
        page_size = use_cases.count
      end
    end

    results = {
      url: request.original_url,
      count: use_cases.count,
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if use_cases.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = use_cases.paginate(page: current_page, per_page: page_size)

    uri.fragment = uri.query = nil

    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-use-cases')
      end
      format.json do
        render(json: results.to_json(
          UseCase.serialization_options.merge({
            collection_path: uri.to_s,
            include_relationships: true
          })
        ))
      end
    end
  end
end
