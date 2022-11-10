# frozen_string_literal: true

module Mutations
  class CreateUser < Mutations::BaseMutation
    argument :email, String, required: true
    argument :roles, GraphQL::Types::JSON, required: false, default_value: []
    argument :username, String, required: true
    argument :organizations, GraphQL::Types::JSON, required: true, default_value: []
    argument :products, GraphQL::Types::JSON, required: false, default_value: []
    argument :confirmed, Boolean, required: false

    field :user, Types::UserType, null: true
    field :errors, [String], null: true

    def resolve(email:, roles:, username:, organizations:, products:, confirmed:)
      unless an_admin
        return {
          user: nil,
          errors: ['Must be an admin to update user data.']
        }
      end

      user = User.find_by(email: email)
      if user.nil?
        password = random_password
        user = User.new(email: email,
                        created_at: Time.now,
                        password: password,
                        password_confirmation: password)

        send_email_with_password(username, email, password)
      end

      if user.confirmed_at.nil? && confirmed
        user.confirmed_at = Time.now
      end

      user.username = username
      user.roles = roles

      if !organizations.nil? && !organizations.empty?
        org = Organization.find_by(slug: organizations[0]['slug'])
        user.organization_id = org.id
      else
        user.organization_id = nil
      end

      user.user_products = []
      if !products.nil? && !products.empty?
        products.each do |prod|
          curr_prod = Product.find_by(slug: prod['slug'])
          user.user_products << curr_prod.id
        end
      end

      if user.save
        {
          user: user,
          errors: nil
        }
      else
        {
          user: nil,
          errors: user.errors.full_messages
        }
      end
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{e.record.class.name}: " \
        "#{e.record.errors.full_messages.join(', ')}"
      )
    end

    def random_password
      chars = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
      chars.sort_by { rand }.join[0...10]
    end

    def send_email_with_password(username, email, password)
      email_subject = 'Password for your account'

      email_body = "Hi #{username}! <br />Your account have been created.<br />Password: #{password}"

      AdminMailer.send_mail_from_client('notifier@solutions.dial.community',
        email, email_subject, email_body, "text/html").deliver_now
    end
  end
end
