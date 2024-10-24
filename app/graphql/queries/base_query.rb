# frozen_string_literal: true

module Queries
  class BaseQuery < GraphQL::Schema::Resolver
    def valid_slug?(slug)
      return false if slug.nil? || slug.empty?
      !slug.start_with?(GRAPH_QUERY_CONTEXT_KEY.downcase)
    end

    def valid_id?(id)
      return false if id.nil? || id.empty?
      id.start_with?(GRAPH_QUERY_CONTEXT_KEY.downcase)
    end

    def validate_access_to_resource(resource)
      operation_context = context[:operation_context]
      current_policy = Pundit.policy(context[:current_user], resource)

      puts "Receiving resource: #{resource.class} with context: #{operation_context}."
      puts "Processing graph query using policy: #{current_policy.class}."

      unless current_policy.available?
        raise GraphQL::ExecutionError.new(
          'Resource is not available.',
          extensions: { 'code' => BAD_REQUEST }
        )
      end

      if operation_context == VIEWING_CONTEXT
        if !current_policy.view_allowed? && context[:current_user].nil?
          raise GraphQL::ExecutionError.new(
            'Viewing is not allowed.',
            extensions: { 'code' => UNAUTHORIZED }
          )
        end
        if !current_policy.view_allowed? && !context[:current_user].nil?
          raise GraphQL::ExecutionError.new(
            'Viewing is not allowed.',
            extensions: { 'code' => FORBIDDEN }
          )
        end
      else
        if !current_policy.edit_allowed? && context[:current_user].nil?
          raise GraphQL::ExecutionError.new(
            "#{operation_context.titlecase} is not allowed.",
            extensions: { 'code' => UNAUTHORIZED }
          )
        end
        if !current_policy.edit_allowed? && !context[:current_user].nil?
          raise GraphQL::ExecutionError.new(
            "#{operation_context.titlecase} is not allowed.",
            extensions: { 'code' => FORBIDDEN }
          )
        end
      end
    end

    def unsecured_read_allowed
      current_tenant = ExchangeTenant.find_by(tenant_name: Apartment::Tenant.current)
      current_tenant.nil? ? true : current_tenant.allow_unsecured_read
    end

    def an_admin
      !context[:current_user].nil? && context[:current_user].roles.include?('admin')
    end

    def an_adli_admin
      return false if context[:current_user].nil?

      context[:current_user].roles.include?('adli_admin')
    end

    def a_content_editor
      !context[:current_user].nil? && context[:current_user].roles.include?('content_editor')
    end
  end
end
