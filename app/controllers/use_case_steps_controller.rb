# frozen_string_literal: true

class UseCaseStepsController < ApplicationController
  def unique_search
    record = UseCaseStep.find_by(slug: params[:step_id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(UseCaseStep.serialization_options
                                           .merge({
                                             item_path: request.original_url,
                                             include_relationships: true
                                           })))
  end

  def simple_search
    default_page_size = 20
    use_case_steps = UseCase.find_by(slug: params[:id])
                            .use_case_steps

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    use_case_steps = use_case_steps.name_contains(params[:search]) if params[:search].present?

    use_case_steps = use_case_steps.paginate(page: current_page, per_page: default_page_size)

    results = {
      url: request.original_url,
      count: use_case_steps.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if use_case_steps.count > default_page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = use_case_steps

    uri.fragment = uri.query = nil
    render(json: results.to_json(UseCaseStep.serialization_options
                                            .merge({
                                              collection_path: uri.to_s,
                                              include_relationships: true
                                            })))
  end

  def complex_search
    default_page_size = 20
    use_case_steps = UseCase.find_by(slug: params[:id])
                            .use_case_steps

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    use_case_steps = use_case_steps.name_contains(params[:search]) if params[:search].present?

    use_case_steps = use_case_steps.paginate(page: current_page, per_page: default_page_size)

    results = {
      url: request.original_url,
      count: use_case_steps.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if use_case_steps.count > default_page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = use_case_steps

    uri.fragment = uri.query = nil
    render(json: results.to_json(UseCaseStep.serialization_options
                                            .merge({
                                              collection_path: uri.to_s,
                                              include_relationships: true
                                            })))
  end
end
