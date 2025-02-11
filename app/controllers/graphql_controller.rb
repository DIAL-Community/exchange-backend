# frozen_string_literal: true

class GraphqlController < ApplicationController
  # before_action :authenticate_user!
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  protect_from_forgery with: :null_session

  # before_action :block_unknown_remote_addresses
  def block_unknown_remote_addresses
    allowed_addresses = ENV['ALLOWED_REMOTE_ADDRESSES'].to_s.split(',').collect(&:strip)
    logger.info("GraphQL request coming from: #{request.remote_ip}")
    unless allowed_addresses.include?(request.remote_ip)
      render(json: { message: 'Operation not authorized.' }, status: :unauthorized)
    end
  end

  def execute
    query = params[:query]
    operation_name = params[:operationName]
    variables = prepare_variables(params[:variables])
    context = {
      current_user:,
      operation_name:,
      operation_context:
    }
    result = RegistrySchema.execute(query, variables:, context:, operation_name:)
    render(json: result)
  rescue StandardError => e
    handle_error_in_development(e)
  end

  private

  def operation_context
    request.headers[GRAPH_QUERY_CONTEXT_KEY]
  end

  def current_user
    return nil if request.headers['Authorization'].blank?

    token = request.headers['Authorization'].split(' ').last
    return nil if token.blank?

    User.find_by(authentication_token: token)
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      # GraphQL-Ruby will validate name and type of incoming variables.
      variables_param.to_unsafe_hash
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error(e.message)
    logger.error(e.backtrace.join("\n"))

    render(json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500)
  end
end
