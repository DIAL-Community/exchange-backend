# frozen_string_literal: true

require 'faraday'
require 'base64'
require 'modules/slugger'

class ApplicationController < ActionController::Base
  include Modules::Slugger
  include Pundit::Authorization
  protect_from_forgery prepend: true

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_default_identifier
  around_action :prepare_locale

  def default_url_options
    if !request.query_parameters['user_token'].nil?
      {
        'user_email': request.query_parameters['user_email'],
        'user_token': request.query_parameters['user_token']
      }
    else
      {}
    end
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def set_default_identifier
    logger.info("Default session identifier: #{session[:default_identifier]}.")
    if session[:default_identifier].nil?
      session[:default_identifier] = SecureRandom.uuid

      if request.path_info.include?('/api/v1/')
        user_event = UserEvent.new
        user_event.identifier = session[:default_identifier]

        user_event.event_type = UserEvent.event_types[:api_request]
        user_event.event_datetime = Time.now

        logger.info("User event '#{user_event.event_type}' for #{user_event.identifier} saved.") if user_event.save!
      end
    end
  end

  def prepare_locale(&action)
    if params[:locale].present?
      accept_language = params[:locale]
      I18n.locale = accept_language[0..1].to_sym if I18n.available_locales.index(accept_language[0..1].to_sym)
      session[:locale] = I18n.locale.to_s
    end

    if session[:locale].nil?
      accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
      if accept_language
        accept_language.scan(/[a-z]{2}(?=;)/).first
        I18n.locale = accept_language[0..1].to_sym if I18n.available_locales.index(accept_language[0..1].to_sym)
      end
      session[:locale] = I18n.locale.to_s
    end

    logger.info("Setting locale to '#{session[:locale]}.'")
    I18n.with_locale(session[:locale], &action)
  end

  def generate_offset(first_duplicate)
    size = 1
    unless first_duplicate.nil?
      size = first_duplicate.slug
                            .slice(/_dup\d+$/)
                            .delete('^0-9')
                            .to_i + 1
      logger.info("Slug dupes: #{first_duplicate.slug
                                                .slice(/_dup\d+$/)
                                                .delete('^0-9')
                                                .to_i}")
    end
    "_dup#{size}"
  end

  def send_email
    if params[:email_token] != ENV['EMAIL_TOKEN']
      return respond_to { |format| format.json { render(json: {}, status: :unauthorized) } }
    end

    email_body = "Issue Reported by #{params[:name]}(#{params[:email]}) \n\n" \
                 "Issue Type: #{params[:issue_type]}\n\n#{params[:issue]}"
    AdminMailer.send_mail_from_client('notifier@exchange.dial.global', 'issues@exchange.dial.global',
                                      'User Reported Issue ', email_body).deliver_now

    respond_to do |format|
      format.json { render(json: { email: 'Issue' }, status: :ok) }
    end
  end

  def create_issue
    auth_email = ENV['JIRA_EMAIL']
    auth_token = ENV['JIRA_TOKEN']

    # Project list in JIRA. Adding this for reference.
    _project_keys = [
      ['bb-information-mediation', 'IM'],
      ['bb-consent', 'CON'],
      ['bb-digital-registries', 'DR'],
      ['bb-identity', 'ID'],
      ['bb-messaging', 'MSG'],
      ['bb-payments', 'PAY'],
      ['bb-registration', 'REG'],
      ['bb-scheduler', 'SKD'],
      ['bb-workflow', 'WF'],
      ['bb-ux', 'UX'],
      ['bb-esignature', 'SIG'],
      ['bb-emarketplace', 'MKT'],
      ['bb-cms', 'CMS'],
      ['bb-cloud-infrastructure-hosting', 'INF'],
      ['govstack-country-engagement-playbook', 'GSCIJ'],
      ['use-cases', 'PRD'],
      ['sandbox', 'SND'],
      ['default-value', 'TECH']
    ]

    connection = Faraday.new(
      url: 'https://govstack-global.atlassian.net',
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Authorization' => "Basic #{Base64.strict_encode64(auth_email + ':' + auth_token)}"
      }
    )

    email_address = Base64.decode64(params[:encoded_email])

    start_at = 0
    max_results = 20

    bot_account = nil
    user_account = nil

    searching_bot = true
    searching_user = true
    while searching_user || searching_bot
      response = connection.get('/rest/api/3/users/search') do |request|
        request.params['startAt'] = start_at
        request.params['maxResults'] = max_results
      end
      user_list = JSON.parse(response.body)
      user_list.each do |current_user|
        next if current_user['active'].to_s == 'false'

        if current_user['emailAddress'] == email_address
          puts "Searching email: #{email_address}, resolving: #{current_user['accountId']}."
          user_account = current_user
          searching_user = false
        end

        if current_user['emailAddress'] == auth_email
          puts "Searching auth email: #{auth_email}, resolving: #{current_user['accountId']}."
          bot_account = current_user
          searching_bot = false
        end

        next unless user_account.nil? && current_user['displayName'] == params[:name]

        puts "Searching name: #{params[:name]}, resolving: #{current_user['accountId']}."
        user_account = current_user
        searching_user = false
      end

      if user_list.count < max_results
        searching_bot = false
        searching_user = false
      else
        start_at += user_list.count
      end
    end

    if user_account.nil?
      puts "Not finding user with email: #{email_address} or name: #{params[:name]}."
      unless bot_account.nil?
        puts "Defaulting reporter to bot account."
      end
    end

    request_body = {
      fields: {
        project: {
          key: params[:project_key]
        },
        issuetype: {
          id: 10002
        },
        summary: 'Feedback on specifications, submitted by ' + params[:name] + ' (' + params[:encoded_email] + ')',
        description: {
          type: 'doc',
          version: 1,
          content: [{
            type: 'paragraph',
            content: [{
              text: params[:name] + ' submitted the following feedback for page: ' \
                      + params[:issue_page] + '. ' + params[:issue],
              type: 'text'
            }]
          }]
        }
      }
    }

    response = connection.post('/rest/api/3/issue') do |request|
      unless user_account.nil?
        request_body[:fields][:reporter] = { accountId: user_account['accountId'] }
      end
      if user_account.nil? && !bot_account.nil?
        request_body[:fields][:reporter] = { accountId: bot_account['accountId'] }
      end
      request.body = request_body.to_json
    end

    response_json = JSON.parse(response.body)
    respond_to do |format|
      format.json { render(json: { data: response_json }, status: response.status) }
    end
  end

  private

  def user_not_authorized(exception)
    respond_to do |format|
      format.html do
        redirect_to(request.referrer || root_path,
                    flash: { error: t(exception.query.to_s), scope: 'pundit', default: :default })
      end
      format.json { render(json: {}, status: 401) }
    end
  end
end
