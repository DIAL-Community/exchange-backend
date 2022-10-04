# frozen_string_literal: true

class SustainableDevelopmentGoalsController < ApplicationController
  include ApiFilterConcern

  def unique_search
    record = SustainableDevelopmentGoal.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(SustainableDevelopmentGoal.serialization_options
                                                          .merge({
                                                            item_path: request.original_url,
                                                            include_relationships: true
                                                          })))
  end

  def simple_search
    default_page_size = 20
    sdgs = SustainableDevelopmentGoal.order(:number)

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    if valid_array_parameter(params[:sdgs])
      sdgs = sdgs.where('sustainable_development_goals.slug in (?)', params[:sdgs])
    end

    if params[:search].present?
      sdg_name = sdgs.name_contains(params[:search])
      sdg_desc = sdgs.where('LOWER(long_title) like LOWER(?)', "%#{params[:search]}%")
      sdg_target = sdgs.joins(:sdg_targets).where('LOWER(sdg_targets.name) like LOWER(?)', "%#{params[:search]}%")
      sdgs = sdgs.where(id: (sdg_name + sdg_desc + sdg_target).uniq)
    end

    results = {
      url: request.original_url,
      count: sdgs.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if sdgs.count > default_page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = sdgs.paginate(page: current_page, per_page: default_page_size)
                             .order(:number)

    ## Should we do granular and control it using params like this?
    # relationship_options = {}
    # if params[:include_products].present? && params[:include_products].to_s.downcase == 'true'
    #   relationship_options[:include_products] = true
    # end
    # if params[:include_use_cases].present? && params[:include_use_cases].to_s.downcase == 'true'
    #   relationship_options[:include_use_cases] = true
    # end
    # render(json: results.to_json(SustainableDevelopmentGoal.serialization_options
    #                                                        .merge(relationship_options)
    #                                                        .merge({
    #                                                          collection_path: uri.to_s
    #                                                        })))
    uri.fragment = uri.query = nil

    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-sdgs')
      end
      format.json do
        render(json: results.to_json(SustainableDevelopmentGoal.serialization_options
                                                               .merge({
                                                                 include_relationships: true,
                                                                 collection_path: uri.to_s
                                                               })))
      end
    end
  end
end
