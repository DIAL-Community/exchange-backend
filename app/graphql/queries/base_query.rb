# frozen_string_literal: true

module Queries
  class BaseQuery < GraphQL::Schema::Resolver
    def validate_access_to_resource(resource)
      operation_context = context[:operation_context]
      current_policy = Pundit.policy(context[:current_user], resource)
      if !current_policy.available?
        raise GraphQL::ExecutionError.new(
          'Building block is not available.',
          extensions: { 'code' => BAD_REQUEST }
        )
      elsif operation_context == EDITING_CONTEXT
        if context[:current_user].nil?
          raise GraphQL::ExecutionError.new(
            'Editing is not allowed.',
            extensions: { 'code' => UNAUTHORIZED }
          )
        elsif !current_policy.update_allowed?
          raise GraphQL::ExecutionError.new(
            'Editing is not allowed.',
            extensions: { 'code' => FORBIDDEN }
          )
        end
      elsif operation_context == VIEWING_CONTEXT
        unless current_policy.view_allowed?
          raise GraphQL::ExecutionError.new(
            'Viewing is not allowed.',
            extensions: { 'code' => FORBIDDEN }
          )
        end
      end
    end

    def unsecure_read_allowed
      current_tenant = ExchangeTenant.find_by(tenant_name: Apartment::Tenant.current)
      current_tenant.nil? ? true : current_tenant.allow_unsecure_read
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
