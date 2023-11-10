# frozen_string_literal: true

class OpportunitiesController < ApplicationController
  include OpportunitiesHelper
  include ApiFilterConcern

  def govstack_search
    page_size = 20
    opportunities = Opportunity.where(gov_stack_entity: true)

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    opportunities = opportunities.name_contains(params[:search]) if params[:search].present?

    if params[:origins].present?
      origins = params[:origins].reject { |x| x.nil? || x.empty? }
      unless origins.empty?
        opportunities = opportunities.joins(:origins)
                                     .where(origins: { slug: origins })
      end
    end

    if params[:page_size].present?
      if params[:page_size].to_i.positive?
        page_size = params[:page_size].to_i
      elsif params[:page_size].to_i.negative?
        page_size = opportunities.count
      end
    end

    results = {
      url: request.original_url,
      count: opportunities.count,
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if opportunities.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = opportunities.paginate(page: current_page, per_page: page_size)
                                      .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-opportunities')
      end
      format.json do
        render(json: results.to_json(
          Opportunity.serialization_options.merge({
            collection_path: uri.to_s,
            include_relationships: true,
            govstack_path: true
          })
        ))
      end
    end
  end

  def govstack_unique_search
    record = Opportunity.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(
      Opportunity.serialization_options.merge({
        item_path: request.original_url,
        include_relationships: true,
        govstack_path: true
      })
    ))
  end

  def unique_search
    record = Opportunity.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(
      Opportunity.serialization_options.merge({
        item_path: request.original_url,
        include_relationships: true
      })
    ))
  end

  def simple_search
    page_size = 20
    opportunities = Opportunity

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    opportunities = opportunities.name_contains(params[:search]) if params[:search].present?

    if params[:origins].present?
      origins = params[:origins].reject { |x| x.nil? || x.empty? }
      unless origins.empty?
        opportunities = opportunities.joins(:origins)
                                     .where(origins: { slug: origins })
      end
    end

    if params[:page_size].present?
      if params[:page_size].to_i.positive?
        page_size = params[:page_size].to_i
      elsif params[:page_size].to_i.negative?
        page_size = opportunities.count
      end
    end

    results = {
      url: request.original_url,
      count: opportunities.count,
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if opportunities.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = opportunities.paginate(page: current_page, per_page: page_size)
                                      .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-opportunities')
      end
      format.json do
        render(json: results.to_json(
          Opportunity.serialization_options.merge({
            collection_path: uri.to_s,
            include_relationships: true
          })
        ))
      end
    end
  end
end
