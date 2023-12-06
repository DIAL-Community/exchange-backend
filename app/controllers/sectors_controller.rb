# frozen_string_literal: true

class SectorsController < ApplicationController
  def unique_search
    record = Sector.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(Sector.serialization_options
                                      .merge({
                                        item_path: request.original_url,
                                        include_relationships: true
                                      })))
  end

  def simple_search
    default_page_size = 20
    sectors = Sector.order(:slug)

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    sectors = sectors.name_contains(params[:search]) if params[:search].present?

    sectors = sectors.paginate(page: current_page, per_page: default_page_size)

    results = {
      url: request.original_url,
      count: sectors.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if sectors.count > default_page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = sectors

    uri.fragment = uri.query = nil
    render(json: results.to_json(Sector.serialization_options
                                       .merge({
                                         collection_path: uri.to_s,
                                         include_relationships: true
                                       })))
  end

  def complex_search
    default_page_size = 20
    sectors = Sector.order(:slug)

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    sectors = sectors.name_contains(params[:search]) if params[:search].present?
    sectors = sectors.paginate(page: current_page, per_page: default_page_size)

    results = {
      url: request.original_url,
      count: sectors.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if sectors.count > default_page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = sectors

    uri.fragment = uri.query = nil
    render(json: results.to_json(Sector.serialization_options
                                       .merge({
                                         collection_path: uri.to_s,
                                         include_relationships: true
                                       })))
  end
end
