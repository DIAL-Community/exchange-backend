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

    def validate_access_to_instance(instance)
      operation_context = context[:operation_context]
      current_policy = Pundit.policy(context[:current_user], instance)

      puts "Receiving instance: #{instance.class} with context: #{operation_context}."
      puts "Processing query using policy: #{current_policy.class}."

      unless current_policy.available?
        raise GraphQL::ExecutionError.new(
          'Resource is not available.',
          extensions: { 'code' => BAD_REQUEST }
        )
      end

      operation_context.split(',').each do |operation|
        sanitized_operation = operation.strip.downcase
        # Check if we need to append error to the context.
        operation_permitted = false
        case sanitized_operation
        when VIEWING_CONTEXT
          operation_permitted = !current_policy.view_allowed?
        when EDITING_CONTEXT
          operation_permitted = !current_policy.edit_allowed?
        when DELETING_CONTEXT
          operation_permitted = !current_policy.delete_allowed?
        when CREATING_CONTEXT
          operation_permitted = !current_policy.create_allowed?
        end

        # Check the next operation if current operation is allowed.
        next unless operation_permitted
        # Operation is not allowed, append error to the context.
        context[:current_user].nil? ? error_code = UNAUTHORIZED : error_code = FORBIDDEN
        context.add_error(
          GraphQL::ExecutionError.new(
            "#{sanitized_operation.titlecase} is not allowed.",
            extensions: { 'code' => error_code, operation: sanitized_operation }
          )
        )
      end
    end

    def validate_access_to_resource(resource)
      operation_context = context[:operation_context]
      current_policy = Pundit.policy(context[:current_user], resource)

      puts "Receiving resource: #{resource.class} with context: #{operation_context}."
      puts "Processing query using policy: #{current_policy.class}."

      unless current_policy.available?
        raise GraphQL::ExecutionError.new(
          'Resource is not available.',
          extensions: { 'code' => BAD_REQUEST }
        )
      end

      should_raise_graph_query_error = false
      case operation_context
      when VIEWING_CONTEXT
        should_raise_graph_query_error = !current_policy.view_allowed?
      when EDITING_CONTEXT
        should_raise_graph_query_error = !current_policy.edit_allowed?
      when DELETING_CONTEXT
        should_raise_graph_query_error = !current_policy.delete_allowed?
      when CREATING_CONTEXT
        should_raise_graph_query_error = !current_policy.create_allowed?
      end

      if should_raise_graph_query_error
        context[:current_user].nil? ? error_code = UNAUTHORIZED : error_code = FORBIDDEN
        raise GraphQL::ExecutionError.new(
          "#{operation_context.titlecase} is not allowed.",
          extensions: { 'code' => error_code }
        )
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
