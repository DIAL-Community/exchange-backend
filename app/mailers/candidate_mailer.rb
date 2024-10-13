# frozen_string_literal: true
class CandidateMailer < ActionMailer::Base
  def notify_candidate_status_update
    params[:candidate]
    current_user = params[:current_user]

    params[:current_status]
    params[:previous_status]

    mail(
      from: 'Exchange System Notification <system@exchange>',
      to: "#{current_user.username} <#{current_user.email}>",
      subject: email_subject,
      body: email_body
    )
  end
end
