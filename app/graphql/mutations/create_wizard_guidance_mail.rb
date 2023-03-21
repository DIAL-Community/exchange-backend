# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateWizardGuidanceMail < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :email_address, String, required: true
    argument :message, String, required: true

    field :response, String, null: true

    def resolve(name:, email_address:, message:)
      admin_users = User.where(receive_admin_emails: true)

      email_subject = 'Recommendation Wizard Request'

      email_body = "name: #{name} <br />email: #{email_address}<br />request: #{message}"

      admin_users.each do |admin|
        AdminMailer.send_mail_from_client('notifier@exchange.dial.global',
          admin.email, email_subject, email_body, "text/html").deliver_now
      end

      {
        response: "Message sent successfully"
      }
    end
  end
end
