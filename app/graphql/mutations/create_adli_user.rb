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
      unless an_admin || an_adli_admin
        return {
          user: nil,
          errors: ['Must be an admin or ADLI admin to create / update user data.']
        }
      end

      user = User.find_by(email:)
      if user.nil?
        password = random_password
        user = User.new(
          email:,
          created_at: Time.now,
          password:,
          password_confirmation: password
        )
      end
      assign_auditable_user(user)

      if user.confirmed_at.nil? && confirmed
        user.confirmed_at = Time.now
      end

      user.roles = roles
      user.username = username

      if user.save
        send_email_with_password(username, email)
        { user:, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(
        "Invalid attributes for #{e.record.class.name}: " \
        "#{e.record.errors.full_messages.join(', ')}"
      )
    end

    def random_password
      chars = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
      chars.sort_by { rand }.join[0...10]
    end

    def send_email_with_password(username, email)
      email_subject = 'Password for your account'

      email_body = "Hi #{username}! <br />Your account have been created.<br />"

      AdminMailer.send_mail_from_client(
        'notifier@exchange.dial.global',
        email, email_subject, email_body, "text/html"
      ).deliver_now
    end
  end
end
