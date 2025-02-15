# frozen_string_literal: true

module Queries
  class UserQuery < Queries::BaseQuery
    argument :user_id, String, required: true
    type Types::UserType, null: true

    def resolve(user_id:)
      # Only logged in user can execute this graph query.
      return nil if context[:current_user].nil?

      current_user_id = context[:current_user].id
      # Prevent accessing other contact if the current context is not an admin user.
      return nil if !an_admin && !an_adli_admin && current_user_id.to_s != user_id

      User.find_by(id: user_id.to_i)
    end
  end

  class UsersQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::UserType], null: false

    def resolve(search:)
      return [] unless an_admin || an_adli_admin

      users = User.name_contains(search) unless search.blank?

      if an_adli_admin
        users = users.where('roles && ARRAY[?]::user_role[]', ['adli_admin', 'adli_user'])
      end

      users
    end
  end

  class UserAuthenticationTokenCheckQuery < Queries::BaseQuery
    argument :user_id, Integer, required: true
    argument :user_authentication_token, String, required: true
    type Boolean, null: false

    def resolve(user_id:, user_authentication_token:)
      return false if context[:current_user].nil? || context[:current_user].id != user_id

      token = User.find_by(id: user_id).authentication_token
      token == user_authentication_token
    end
  end

  class UserRolesQuery < Queries::BaseQuery
    type GraphQL::Types::JSON, null: false

    def resolve
      return User.user_roles.values if an_admin
      return [User.user_roles['adli_user'], User.user_roles['adli_admin']] if an_adli_admin

      []
    end
  end

  class UserEmailCheckQuery < Queries::BaseQuery
    argument :email, String, required: true
    type Boolean, null: false

    def resolve(email:)
      return false unless an_admin || an_adli_admin

      email_exists = false
      unless User.find_by(email:).nil?
        email_exists = true
      end
      email_exists
    end
  end
end
