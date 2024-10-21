# frozen_string_literal: true

require 'csv'
require 'modules/geocode'

class OrganizationsController < ApplicationController
  include OrganizationsHelper
  include Modules::Geocode

  def unique_search
    record = Organization.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.as_json(
      Organization.serialization_options
                  .merge({
                    item_path: request.original_url,
                    include_relationships: true
                  })
    ))
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
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if organizations.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = organizations.paginate(page: current_page, per_page: page_size)
                                      .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-organizations')
      end
      format.json do
        render(json: results.to_json(
          Organization.serialization_options
                      .merge({
                        collection_path: uri.to_s,
                        include_relationships: true
                      })
        ))
      end
    end
  end

  def complex_search
    page_size = 20
    organizations = Organization.order(:slug)

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    if params[:aggregator].present? && params[:aggregator].to_s.downcase == 'true'
      organizations = organizations.where(is_mni: true)
    end

    if params[:endorser].present? && params[:endorser].to_s.downcase == 'true'
      organizations = organizations.where(is_endorser: true)
    end

    search = params[:search]
    unless search.blank?
      name_filter = organizations.name_contains(search)
      desc_filter = organizations.left_joins(:organization_descriptions)
                                 .where('LOWER(organization_descriptions.description) like LOWER(?)', "%#{search}%")
      organizations = organizations.where(id: (name_filter + desc_filter).uniq)
    end

    if params[:countries].present?
      countries = params[:countries].reject { |x| x.nil? || x.empty? }
      unless countries.empty?
        organizations = organizations.joins(:countries)
                                     .where(countries: { slug: countries })
      end
    end

    if params[:sectors].present?
      sectors = params[:sectors].reject { |x| x.nil? || x.empty? }
      unless sectors.empty?
        organizations = organizations.joins(:sectors)
                                     .where(sectors: { slug: sectors })
      end
    end

    if params[:years].present?
      years = params[:years].reject { |x| x.nil? || x.empty? }
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
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if organizations.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    current_user = User.find_by(
      email: request.headers['X-User-Email'],
      authentication_token: request.headers['X-User-Token']
    )

    privileged_user = !current_user.nil? && (
      current_user.roles.include?('admin') ||
      current_user.roles.include?('principle')
    )

    results['results'] = organizations.paginate(page: current_page, per_page: page_size)
                                      .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv({ privileged_user: }), filename: 'csv-organizations')
      end
      format.json do
        render(json: results.to_json(
          Organization.serialization_options
                      .merge({
                        collection_path: uri.to_s,
                        include_relationships: true,
                        privileged_user:
                      })
        ))
      end
    end
  end
end
