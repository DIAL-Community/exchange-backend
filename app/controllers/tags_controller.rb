# frozen_string_literal: true

class TagsController < ApplicationController
  def unique_search
    record = Tag.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.to_json(Tag.serialization_options))
  end

  def simple_search
    default_page_size = 20
    tags = Tag.order(:slug)

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    tags = tags.name_contains(params[:search]) if params[:search].present?

    tags = tags.paginate(page: current_page, per_page: default_page_size)

    results = {
      url: request.original_url,
      count: tags.count,
      page_size: default_page_size
    }

    results['next_page'] = current_page + 1 if tags.count > default_page_size * current_page
    results['previous_page'] = current_page - 1 if current_page > 1
    results['results'] = tags

    render(json: results.to_json(Tag.serialization_options))
  end

  def complex_search
    default_page_size = 20
    tags = Tag.order(:slug)

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    tags = tags.name_contains(params[:search]) if params[:search].present?

    tags = tags.paginate(page: current_page, per_page: default_page_size)

    results = {
      url: request.original_url,
      count: tags.count,
      page_size: default_page_size
    }

    results['next_page'] = current_page + 1 if tags.count > default_page_size * current_page
    results['previous_page'] = current_page - 1 if current_page > 1
    results['results'] = tags

    render(json: results.to_json(Tag.serialization_options))
  end
end
