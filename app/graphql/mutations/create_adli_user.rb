# frozen_string_literal: true

module Mutations
  class CreateAdliUser < Mutations::BaseMutation
    argument :email, String, required: true
    argument :roles, GraphQL::Types::JSON, required: false, default_value: []
    argument :username, String, required: true
    argument :confirmed, Boolean, required: false

    field :user, Types::UserType, null: true
    field :errors, [String], null: true

    def resolve(email:, roles:, username:, confirmed:)
      # Find the correct policy
      user = User.find_by(email:)
      user_policy = Pundit.policy(context[:current_user], user || User.new)
      unless user_policy.create_allowed?
        return {
          user: nil,
          errors: ['Must be an admin to create / update user data.']
        }
      end

      if user.nil?
        password = random_password
        user = User.new(email:, created_at: Time.now, password:, password_confirmation: password)
      end
      assign_auditable_user(user)

      if user.confirmed_at.nil? && confirmed
        user.confirmed_at = Time.now
      end

      user.roles = roles
      user.username = username

      if user.save
        send_email_with_password(username, email, password)
        { user:, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(
        "Invalid attributes for #{e.record.class.name}.",
        extensions: { 'code' => UNAUTHORIZED }
      )
    end

    def random_password
      chars = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
      chars.sort_by { rand }.join[0...10]
    end

    def send_email_with_password(username, email, password)
      email_subject = 'Password for your account'

      email_body = "Hi #{username}! <br />Your account has been created.<br />
        Your temporary password is: #{password}<br />
        Please log in using this password and use the 'My Profile' page to change your password."

      AdminMailer.send_mail_from_client(
        'notifier@exchange.dial.global',
        email, email_subject, email_body, "text/html"
      ).deliver_now
    end
  end
end
