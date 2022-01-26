module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :password, String, null: false
    field :reset_password_token, String, null: true
    field :reset_password_sent_at, GraphQL::Types::ISO8601DateTime, null: true
    field :remember_created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :confirmation_token, String, null: true
    field :confirmed_at, GraphQL::Types::ISO8601DateTime, null: true
    field :confirmation_sent_at, GraphQL::Types::ISO8601DateTime, null: true
    field :unconfirmed_email, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :role, String, null: false
    field :receive_backup, Boolean, null: true
    field :organization_id, Integer, null: true
    field :expired, Boolean, null: true
    field :expired_at, GraphQL::Types::ISO8601DateTime, null: true
    field :saved_products, Integer, null: true
    field :saved_use_cases, Integer, null: true
    field :saved_projects, Integer, null: true
    field :saved_urls, String, null: true
  end
end
