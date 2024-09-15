# frozen_string_literal: true

class ProductsController < ApplicationController
  include ProductsHelper
  include ApiFilterConcern

  def govstack_search
    page_size = 20
    products = Product.where(gov_stack_entity: true)

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
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = products.paginate(page: current_page, per_page: page_size)
                                 .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-products')
      end
      format.json do
        render(json: results.to_json(
          Product.serialization_options.merge({
            collection_path: uri.to_s,
            include_relationships: true,
            govstack_path: true
          })
        ))
      end
    end
  end

  def govstack_unique_search
    record = Product.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(
      Product.serialization_options.merge({
        item_path: request.original_url,
        include_relationships: true,
        govstack_path: true
      })
    ))
  end

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

    render(json: record.to_json(
      Product.serialization_options.merge({
        item_path: request.original_url,
        include_relationships: true
      })
    ))
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
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = products.paginate(page: current_page, per_page: page_size)
                                 .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-products')
      end
      format.json do
        render(json: results.to_json(
          Product.serialization_options.merge({
            collection_path: uri.to_s,
            include_relationships: true
          })
        ))
      end
    end
  end

  def filter_building_blocks(sdgs, use_cases, workflows, building_blocks, is_linked_with_dpi)
    filtered = false

    sdg_use_case_ids = []
    filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
    unless filtered_sdgs.empty?
      filtered = true
      sdg_numbers = SustainableDevelopmentGoal.where(slug: filtered_sdgs)
                                              .select(:number)
      sdg_use_cases = UseCase.joins(:sdg_targets)
                             .where(sdg_targets: { sdg_number: sdg_numbers })
      sdg_use_case_ids += sdg_use_cases.ids unless sdg_use_cases.empty?
    end

    use_case_ids = []
    filtered_use_cases = use_cases.reject { |x| x.nil? || x.empty? }
    unless filtered_use_cases.empty?
      use_case_ids += UseCase.where(slug: filtered_use_cases).ids
    end

    workflow_slugs = []
    filtered_use_cases = sdg_use_case_ids + use_case_ids
    unless filtered_use_cases.empty?
      filtered = true
      use_case_workflows = Workflow.joins(:use_case_steps)
                                   .where(use_case_steps: { use_case_id: filtered_use_cases })
      workflow_slugs += use_case_workflows.map(&:slug) unless use_case_workflows.empty?
    end

    building_block_slugs = []
    filtered_workflows = workflow_slugs + workflows.reject { |x| x.nil? || x.empty? }
    unless filtered_workflows.empty?
      filtered = true
      workflow_building_blocks = BuildingBlock.joins(:workflows)
                                              .where(workflows: { slug: filtered_workflows })
      building_block_slugs += workflow_building_blocks.map(&:slug) unless workflow_building_blocks.empty?
    end

    building_block_slugs += building_blocks.reject { |x| x.nil? || x.empty? }
    filtered = true unless building_blocks.empty?

    if is_linked_with_dpi
      filtered = true
      dpi_building_block = BuildingBlock.category_types[:DPI]
      dpi_building_blocks = BuildingBlock.where(category: dpi_building_block)
      unless building_block_slugs.empty?
        dpi_building_blocks = dpi_building_blocks.where(slug: building_block_slugs)
      end
      building_block_slugs = dpi_building_blocks.map(&:slug)
    end

    [filtered, building_block_slugs]
  end

  def complex_search
    page_size = 20

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    puts "Parameters: #{params.inspect}"

    products = Product.order(:name).distinct
    filtered, building_block_slugs = filter_building_blocks(
      params[:sdgs],
      params[:use_cases],
      params[:workflows],
      params[:building_blocks],
      params[:is_linked_with_dpi]
    )
    if filtered
      if building_block_slugs.empty?
        # Filter is active, but all the filters are resulting in empty building block array.
        # All bb is filtered out, return no product.
        return []
      else
        products = products.joins(:building_blocks)
                           .where(building_blocks: { slug: building_block_slugs })
      end
    end

    search = params[:search]
    if !search.nil? && !search.to_s.strip.blank?
      name_products = products.name_contains(search)
      desc_products = products.joins(:product_descriptions)
                              .where('LOWER(product_descriptions.description) like LOWER(?)', "%#{search}%")
      alias_products = products.where("LOWER(array_to_string(aliases,',')) like LOWER(?)", "%#{search}%")
      by_sectors = Product.joins(:sectors)
                          .where('LOWER(sectors.name) LIKE LOWER(?)', "%#{search}%")
                          .ids

      products = products.where(id: (name_products + desc_products + alias_products + by_sectors).uniq)
    end

    if params[:show_dpga_only].present? && params[:show_dpga_only].to_s.downcase == 'true'
      products = products.joins(:origins)
                         .where(origins: { slug: 'dpga' })

      products = products.left_outer_joins(:endorsers)
                         .where.not(endorsers: { id: nil })
    end

    if params[:origins].present?
      origins = params[:origins].reject { |x| x.nil? || x.empty? }
      unless origins.empty?
        products = products.joins(:origins)
                           .where(origins: { slug: origins })
      end
    end

    if params[:countries].present?
      filtered_countries = params[:countries].reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        products = products.joins(:countries)
                           .where(countries: { slug: filtered_countries })
      end
    end

    if params[:origins].present?
      filtered_origins = params[:origins].reject { |x| x.nil? || x.empty? }
      unless filtered_origins.empty?
        products = products.joins(:origins)
                           .where(origins: { slug: filtered_origins })
      end
    end

    if params[:sectors].present?
      filtered_sectors = params[:sectors].reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        products = products.joins(:sectors)
                           .where(sectors: { slug: filtered_sectors })
      end
    end

    if params[:tags].present?
      filtered_tags = params[:tags].reject { |x| x.nil? || x.blank? }
      unless filtered_tags.empty?
        tags = Tag.where(slug: filtered_tags).map(&:name)
        products = products.where(
          " tags @> '{#{tags.join(',').downcase}}'::varchar[] or "\
          " tags @> '{#{tags.join(',')}}'::varchar[]"
        )
      end
    end

    if (params[:license_types] - ['oss_only']).empty? && (['oss_only'] - params[:license_types]).empty?
      products = products.where(commercial_product: false)
    elsif (params[:license_types] - ['commercial_only']).empty? && (['commercial_only'] - params[:license_types]).empty?
      products = products.where(commercial_product: true)
    end

    if params[:show_gov_stack_only].present? && params[:show_gov_stack_only].to_s.downcase == 'true'
      products = products.where(gov_stack_entity: true)
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
      results['next_page'] = uri.to_s
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = uri.to_s
    end

    results['results'] = products.paginate(page: current_page, per_page: page_size)
                                 .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-products')
      end
      format.json do
        render(json: results.to_json(
          Product.serialization_options.merge({
            collection_path: uri.to_s,
            include_relationships: true
          })
        ))
      end
    end
  end
end
