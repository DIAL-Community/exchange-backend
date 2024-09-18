# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def send_mail_from_client(mail_from, mail_to, email_subject, email_body, content_type = 'text/plain')
    # issues@exchange.dial.global

    mail(from: mail_from,
         to: mail_to,
         subject: email_subject,
         body: email_body,
         content_type:)
  end

  def default_text
    "\n\nPlease don't reply to this automatically generated service email."
  end

  def notify_user_request
    user_hash = params[:user]

    email_subject = 'New User Sign Up'
    email_body = "New user '#{user_hash[:email]}' created in the exchange. "\
                 'User can do self activation, but admin may need check from time to time for un-activated users.'
    if user_hash[:product_id].present? && !user_hash[:product_id].nil?
      product = Product.find(user_hash[:product_id])
      email_subject = 'Product Owner Request'
      email_body = "User '#{user_hash[:email]}' has requested ownership of: [#{product.name}]. "\
                   'Approval from an admin user is required.'
    elsif user_hash[:organization_id].present? && !user_hash[:organization_id].nil?
      organization = Organization.find(user_hash[:organization_id])
      email_subject = 'Organization Owner Request'
      email_body = "User '#{user_hash[:email]}' has requested ownership of: [#{organization.name}]. "\
                   'Approval from an admin user is required.'
    elsif user_hash[:dataset_id].present? && !user_hash[:dataset_id].nil?
      dataset = Dataset.find(user_hash[:dataset_id])
      email_subject = 'Dataset Owner Request'
      email_body = "User '#{user_hash[:email]}' has requested ownership of: [#{dataset.name}]. "\
                   'Approval from an admin user is required.'
    end

    mail_to = ''
    User.where(receive_admin_emails: true).each do |user|
      next unless user.roles.include?('admin')

      mail_to += "#{user.email}; "
    end

    mail(
      from: 'notifier@exchange.dial.global',
      to: mail_to,
      subject: email_subject,
      body: email_body + default_text
    )
  end

  def notify_owner_approval
    if params[:organization_id].present? && !params[:organization_id].nil?
      organization = Organization.find(params[:organization_id])
      body_part = "You are the owner of [#{organization.name}] now. "
      subject = "Organization Owner Request #{params[:rejected] ? 'Rejected' : 'Approved'}"
    elsif params[:dataset_id].present? && !params[:dataset_id].nil?
      dataset = Dataset.find(params[:dataset_id])
      body_part = "You are the owner of [#{dataset.name}] now. "
      subject = "Dataset Owner Request #{params[:rejected] ? 'Rejected' : 'Approved'}"
    elsif params[:product_id].present? && !params[:product_id].nil?
      product = Product.find(params[:product_id])
      body_part = "You are the owner of [#{product.name}] now. "
      subject = "Product Owner Request #{params[:rejected] ? 'Rejected' : 'Approved'}"
    end

    mail(
      from: 'notifier@exchange.dial.global',
      to: [params[:email]],
      subject:,
      body: (params[:rejected] ? '' : body_part).to_s +
        'Your request in the Exchange (https://exchange.dial.global) have been updated.' +
        default_text
    )
  end

  def notify_new_candidate_record
    mail_to = ''
    User.where(receive_admin_emails: true).each do |user|
      next unless user.roles.include?('admin')

      mail_to += "#{user.email}; "
    end

    mail(
      from: 'notifier@exchange.dial.global',
      to: mail_to,
      subject: "#{params[:object_type]} Created",
      body: 'A new candidate record created. Please log in to see the changes.\n\n'\
            "Candidate name: [#{params[:candidate_name]}].\n\n" \
            "#{default_text}"
    )
  end

  def notify_candidate_record_approval
    mail(
      from: 'notifier@exchange.dial.global',
      to: [params[:user_email]],
      subject: "#{params[:object_type]} #{params[:rejected] ? 'Rejected' : 'Approved'}",
      body: 'Your submission status have been updated in the Exchange (https://exchange.dial.global).' + default_text
    )
  end

  def notify_new_content_editor
    mail_to = ''
    User.where(receive_admin_emails: true).each do |user|
      next unless user.roles.include?('admin')

      mail_to += "#{user.email}; "
    end

    mail(
      from: 'notifier@exchange.dial.global',
      to: mail_to,
      subject: 'Content Editor Request',
      body: "User '#{params[:email]}' has requested elevated role 'Content Editor'. " + default_text
    )
  end

  def send_feedback_email
    mail_to = ''
    if params[:email_token] != ENV['EMAIL_TOKEN']
      return respond_to { |format| format.json { render(json: {}, status: :unauthorized) } }
    end

    email_body = "Issue Reported by #{params[:name]}(#{params[:email]}) \n\n" \
                 "Issue Type: #{params[:issue_type]}\n\n#{params[:issue]}"
    AdminMailer.send_mail_from_client(
      'notifier@exchange.dial.global',
      'issues@exchange.dial.global',
      'User Reported Issue ', email_body
    ).deliver_now

    User.where(receive_admin_emails: true).each do |user|
      next unless user.roles.include?('admin')

      mail_to += "#{user.email}; "
    end

    mail(
      from: 'notifier@exchange.dial.global',
      to: mail_to,
      subject: 'User Reported Issue ',
      body: email_body + default_text
    )
  end
end
