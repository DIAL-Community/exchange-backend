# frozen_string_literal: true

module Queries
  class BaseQuery < GraphQL::Schema::Resolver
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
