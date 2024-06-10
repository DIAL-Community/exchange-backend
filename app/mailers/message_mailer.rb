# frozen_string_literal: true

class MessageMailer < ActionMailer::Base
  def message_action_notification
    current_user = params[:current_user]
    current_contact = params[:current_contact]
    current_message = params[:current_message]

    message_type_humanized = current_message.message_type.gsub('dpi_', '').titleize
    email_subject = "#{message_type_humanized} - #{current_message.name}"

    date_created = current_message.created_at

    current_template = current_message.message_template
    email_body = current_template.gsub('%{user_email}%', current_user.email)
                                 # Replace with current user's name or fallback to username if contact is nil.
                                 .gsub('%{user_name}%', current_contact&.name)
                                 .gsub('%{user_name}%', current_user.username)
                                 # Replace other template literal available for the message object.
                                 .gsub('%{current_date}%', date_created.strftime('%m/%d/%Y'))
                                 .gsub('%{current_time}%', date_created.strftime('%H:%M:%S %:z'))
                                 .gsub('%{current_datetime}%', date_created.strftime('%m/%d/%Y %H:%M:%S %:z'))
                                 .gsub('%{user_username}%', current_user.username)

    mail(
      from: 'Notifier System <system@dpi.dial.community>',
      to: "#{current_contact.name} <#{current_contact.email}>",
      subject: email_subject,
      body: email_body
    )
  end
end
