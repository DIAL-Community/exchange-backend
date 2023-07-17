# frozen_string_literal: true

class ProjectsController < ApplicationController
  def unique_search
    record = Project.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(Project.serialization_options
                                       .merge({
                                         item_path: request.original_url,
                                         include_relationships: true
                                       })))
  end

  def simple_search
    page_size = 20
    projects = Project

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    projects = projects.name_contains(params[:search]) if params[:search].present?

    if params[:origins].present?
      origins = params[:origins].reject { |x| x.nil? || x.empty? }
      projects = projects.where(origin: Origin.where(slug: origins)) \
        unless origins.empty?
    end

    if params[:page_size].present?
      if params[:page_size].to_i.positive?
        page_size = params[:page_size].to_i
      elsif params[:page_size].to_i.negative?
        page_size = projects.count
      end
    end

    results = {
      url: request.original_url,
      count: projects.count,
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if projects.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = CGI.escape(uri.to_s)
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = CGI.escape(uri.to_s)
    end

    results['results'] = projects.paginate(page: current_page, per_page: page_size)
                                 .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-projects')
      end
      format.json do
        render(json: results.to_json(Project.serialization_options
                                            .merge({
                                              collection_path: uri.to_s,
                                              include_relationships: true
                                            })))
      end
    end
  end

  def complex_search
    page_size = 20
    projects = Project

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    projects = projects.name_contains(params[:search]) if params[:search].present?

    if params[:origins].present?
      origins = params[:origins].reject { |x| x.nil? || x.empty? }
      projects = projects.where(origin: Origin.where(slug: origins)) \
        unless origins.empty?
    end

    if params[:sectors].present?
      sectors = params[:sectors].reject { |x| x.nil? || x.empty? }
      unless sectors.empty?
        projects = projects.joins(:sectors)
                           .where('sectors.slug in (?)', sectors)
      end
    end

    if params[:products].present?
      products = params[:products].reject { |x| x.nil? || x.empty? }
      unless products.empty?
        projects = projects.joins(:products)
                           .where('products.slug in (?)', products)
      end
    end

    if params[:organizations].present?
      organizations = params[:organizations].reject { |x| x.nil? || x.empty? }
      unless organizations.empty?
        projects = projects.joins(:organizations)
                           .where('organizations.slug in (?)', organizations)
      end
    end

    if params[:countries].present?
      countries = params[:countries].reject { |x| x.nil? || x.empty? }
      unless countries.empty?
        projects = projects.joins(:countries)
                           .where('countries.slug in (?)', countries)
      end
    end

    if params[:page_size].present?
      if params[:page_size].to_i.positive?
        page_size = params[:page_size].to_i
      elsif params[:page_size].to_i.negative?
        page_size = projects.count
      end
    end

    results = {
      url: request.original_url,
      count: projects.count,
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if projects.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = CGI.escape(uri.to_s)
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = CGI.escape(uri.to_s)
    end

    results['results'] = projects.paginate(page: current_page, per_page: page_size)
                                 .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-projects')
      end
      format.json do
        render(json: results.to_json(Project.serialization_options
                                            .merge({
                                              collection_path: uri.to_s,
                                              include_relationships: true
                                            })))
      end
    end
  end
end
