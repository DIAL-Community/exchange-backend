# frozen_string_literal: true

class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.html { render(template: 'errors/_not_found', layout: 'layouts/error', status: 404) }
      format.all  { render(nothing: true, status: 404) }
    end
  end

  def server_error
    respond_to do |format|
      format.html { render(template: 'errors/_server_error', layout: 'layouts/error', status: 500) }
      format.all  { render(nothing: true, status: 500) }
    end
  end
end
