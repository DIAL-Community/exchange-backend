# frozen_string_literal: true

class ProductsController < ApplicationController
  include ProductsHelper
  include ApiFilterConcern

  def owner_search
    product = Product.find_by(slug: params[:product])
    owner = User.where(":product_id = ANY(user_products)", product_id: product&.id) if product&.id

    verified_captcha = Recaptcha.verify_via_api_call(
      params[:captcha],
      {
        secret_key: Rails.application.secrets.captcha_secret_key,
        skip_remote_ip: true
      }
    )

    respond_to do |format|
      format.json do
        if owner.nil? || !verified_captcha
          render(json: { message: 'Unable to process the request.' }, status: :unprocessable_entity)
        else
          render(json: { owner: owner.as_json(only: :email) }, status: :ok)
        end
      end
    end
  end

  def unique_search
    record = Product.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(Product.serialization_options
                                       .merge({
                                         item_path: request.original_url,
                                         include_relationships: true
                                       })))
  end

  def simple_search
    page_size = 20
    products = Product

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    products = products.name_contains(params[:search]) if params[:search].present?

    if params[:origins].present?
      origins = params[:origins].reject { |x| x.nil? || x.empty? }
      unless origins.empty?
        products = products.joins(:origins)
                           .where(origins: { slug: origins })
      end
    end

    if params[:page_size].present?
      if params[:page_size].to_i.positive?
        page_size = params[:page_size].to_i
      elsif params[:page_size].to_i.negative?
        page_size = products.count
      end
    end

    results = {
      url: request.original_url,
      count: products.count,
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if products.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = CGI.escape(uri.to_s)
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = CGI.escape(uri.to_s)
    end

    results['results'] = products.paginate(page: current_page, per_page: page_size)
                                 .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-products')
      end
      format.json do
        render(json: results.to_json(Product.serialization_options
                                            .merge({
                                              collection_path: uri.to_s,
                                              include_relationships: true
                                            })))
      end
    end
  end

  def complex_search
    page_size = 20
    products = Product

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    products = products.name_contains(params[:search]) if params[:search].present?

    if params[:origins].present?
      origins = params[:origins].reject { |x| x.nil? || x.empty? }
      unless origins.empty?
        products = products.joins(:origins)
                           .where(origins: { slug: origins })
      end
    end

    if params[:tags].present?
      filtered_tags = params[:tags].reject { |x| x.nil? || x.blank? }
      unless filtered_tags.empty?
        products = products.where(
          " tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or "\
          " tags @> '{#{filtered_tags.join(',')}}'::varchar[]"
        )
      end
    end

    if params[:sectors].present?
      sectors = params[:sectors].reject { |x| x.nil? || x.empty? }

      filtered_sectors = []
      sectors.each do |sector|
        current_sector = Sector.find_by(slug: sector)
        filtered_sectors << current_sector.id unless current_sector.nil?
        if current_sector.parent_sector_id.nil?
          child_sectors = Sector.where(parent_sector_id: current_sector.id)
          filtered_sectors += child_sectors.map(&:id)
        end
      end
      unless filtered_sectors.empty?
        products = products.joins(:sectors)
                           .where(sectors: { id: filtered_sectors })
      end
    end

    sdg_use_case_slugs = []
    if valid_array_parameter(params[:sdgs])
      sdg_use_case_slugs = use_cases_from_sdg_slugs(params[:sdgs])
      products = products.joins(:sustainable_development_goals)
                         .where(sustainable_development_goals: { slug: params[:sdgs] })
    end
    if sdg_use_case_slugs.nil? && valid_array_parameter(params[:sustainable_development_goals])
      sdg_use_case_slugs = use_cases_from_sdg_slugs(params[:sustainable_development_goals])
      products = products.joins(:sustainable_development_goals)
                         .where(sustainable_development_goals: { slug: params[:sustainable_development_goals] })
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
    building_block_product_slugs = products_from_building_block_slugs(building_block_slugs)

    product_slugs = building_block_product_slugs
    if valid_array_parameter(params[:products])
      if product_slugs.nil? || product_slugs.empty?
        product_slugs = params[:products] \
      else
        product_slugs &= params[:products] \
      end
    end

    product_slugs = product_slugs.reject { |x| x.nil? || x.empty? } unless product_slugs.nil?
    products = products.where(slug: product_slugs) unless product_slugs.nil? || product_slugs.empty?

    if params[:page_size].present?
      if params[:page_size].to_i.positive?
        page_size = params[:page_size].to_i
      elsif params[:page_size].to_i.negative?
        page_size = products.count
      end
    end

    results = {
      url: request.original_url,
      count: products.count,
      page_size:
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if products.count > page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = CGI.escape(uri.to_s)
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = CGI.escape(uri.to_s)
    end

    results['results'] = products.paginate(page: current_page, per_page: page_size)
                                 .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-products')
      end
      format.json do
        render(json: results.to_json(Product.serialization_options
                                            .merge({
                                              collection_path: uri.to_s,
                                              include_relationships: true
                                            })))
      end
    end
  end
end
