# frozen_string_literal: true

require 'csv'
require 'modules/geocode'

class OrganizationsController < ApplicationController
  include OrganizationsHelper
  include Modules::Geocode

  def unique_search
    record = Organization.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.as_json(Organization.serialization_options
                                            .merge({
                                              item_path: request.original_url,
                                              include_relationships: true
                                            })))
  end

  def simple_search
    page_size = 20
    organizations = Organization

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    organizations = organizations.name_contains(params[:search]) if params[:search].present?

    if params[:page_size].present?
      if params[:page_size].to_i.positive?
        page_size = params[:page_size].to_i
      elsif params[:page_size].to_i.negative?
        page_size = organizations.count
      end
    end

    results = {
      url: request.original_url,
      count: organizations.count,
      page_size: page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if organizations.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = organizations.paginate(page: current_page, per_page: page_size)
                                      .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-organizations')
      end
      format.json do
        render(json: results.to_json(Organization.serialization_options
                                                 .merge({
                                                   collection_path: uri.to_s,
                                                   include_relationships: true
                                                 })))
      end
    end
  end

  def complex_search
    page_size = 20
    organizations = Organization.order(:slug)

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    organizations = organizations.name_contains(params[:search]) if params[:search].present?

    if params[:countries].present?
      countries = params[:countries].reject { |x| x.nil? || x.empty? }
      unless countries.empty?
        organizations = organizations.joins(:countries)
                                     .where('countries.code in (?)', countries)
      end
    end

    if params[:sectors].present?
      sectors = params[:sectors].reject { |x| x.nil? || x.empty? }
      unless sectors.empty?
        organizations = organizations.joins(:sectors)
                                     .where('sectors.slug in (?)', sectors)
      end
    end

    if params[:endorsing_years].present?
      years = params[:endorsing_years].reject { |x| x.nil? || x.empty? }
      organizations = organizations.where('extract(year from when_endorsed) in (?)', years) \
        unless years.empty?
    end

    if params[:page_size].present?
      if params[:page_size].to_i.positive?
        page_size = params[:page_size].to_i
      elsif params[:page_size].to_i.negative?
        page_size = organizations.count
      end
    end

    results = {
      url: request.original_url,
      count: organizations.count,
      page_size: page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if organizations.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = organizations.paginate(page: current_page, per_page: page_size)
                                      .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-organizations')
      end
      format.json do
        render(json: results.to_json(Organization.serialization_options
                                                 .merge({
                                                   collection_path: uri.to_s,
                                                   include_relationships: true
                                                 })))
      end
    end
  end
end
