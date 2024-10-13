# frozen_string_literal: true
class CandidateMailer < ActionMailer::Base
  def notify_candidate_status_update
    current_user = params[:current_user]
    current_candidate = params[:current_candidate]

    sender_email = params[:sender_email]
    destination_email = params[:destination_email]

    current_status = params[:current_status]
    previous_status = params[:previous_status]

    email_subject = "Submission Status Updated to #{current_status}"

    email_body = params[:notification_template]
    unless current_user.nil?
      email_body = email_body.gsub('{{current-user}}', current_user.username)
    end

    email_body = email_body.gsub('{{current-user}}', destination_email)

    email_body = email_body.gsub('{{candidate-name}}', current_candidate.name)

    email_body = email_body.gsub('{{current-status}}', current_status)
    email_body = email_body.gsub('{{previous-status}}', previous_status)

    mail(
      from: sender_email,
      to: "#{destination_email} <#{destination_email}>",
      subject: email_subject,
      body: email_body
    )
  end
end
