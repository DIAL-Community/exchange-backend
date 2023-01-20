# frozen_string_literal: true

module Queries
  class UsersQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::UserType], null: false

    def resolve(search:)
      return [] if context[:current_user].nil? || !context[:current_user].roles.include?('admin')

      users = User.name_contains(search) unless search.blank?
      users
    end
  end

  class UserQuery < Queries::BaseQuery
    argument :user_id, String, required: true
    type Types::UserType, null: true

    def resolve(user_id:)
      return if context[:current_user].nil? || !context[:current_user].roles.include?('admin')

      User.find(user_id)
    end
  end

  class UserAuthenticationTokenCheckQuery < Queries::BaseQuery
    argument :user_id, Integer, required: true
    argument :user_authentication_token, String, required: true
    type Boolean, null: true

    def resolve(user_id:, user_authentication_token:)
      return false if context[:current_user].nil? || context[:current_user].id != user_id

      token = User.find_by(id: user_id).authentication_token
      token == user_authentication_token
    end
  end

  class SearchUsersQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    type Types::UserType.connection_type, null: false

    def resolve(search:)
      return [] if context[:current_user].nil? || !context[:current_user].roles.include?('admin')

      users = User.order(:email)
      users = users.name_contains(search) unless search.blank?

      users.distinct
    end
  end

  class UserRolesQuery < Queries::BaseQuery
    type GraphQL::Types::JSON, null: true

    def resolve
      return nil unless an_admin

      User.user_roles.values
    end
  end

  class UserEmailCheckQuery < Queries::BaseQuery
    argument :email, String, required: true
    type Boolean, null: true

    def resolve(email:)
      email_exists = false

      unless User.find_by(email: email).nil?
        email_exists = true
      end
      email_exists
    end
  end
end
