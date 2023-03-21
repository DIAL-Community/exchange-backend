# frozen_string_literal: true

module Queries
  class BaseQuery < GraphQL::Schema::Resolver
    def an_admin
      !context[:current_user].nil? && context[:current_user].roles.include?('admin')
    end

    def a_content_editor
      !context[:current_user].nil? && context[:current_user].roles.include?('content_editor')
    end
  end
end
