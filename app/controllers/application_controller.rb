# frozen_string_literal: true

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
    AdminMailer.send_mail_from_client('notifier@solutions.dial.community', 'issues@solutions.dial.community',
                                      'User Reported Issue ', email_body).deliver_now

    respond_to do |format|
      format.json { render(json: { email: 'Issue' }, status: :ok) }
    end
  end

  def create_issue
    auth_email = ENV['JIRA_EMAIL']
    auth_token = ENV['JIRA_TOKEN']

    jira_uri = URI.parse("https://govstack-global.atlassian.net/rest/api/3/issue")
    http = Net::HTTP.new(jira_uri.host, jira_uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(jira_uri.path)
    request['Content-Type'] = 'application/json'
    request['Accept'] = 'application/json'
    request['Authorization'] = "Basic " + Base64.strict_encode64(auth_email + ":" + auth_token)
    request.body = {
      'fields': {
        'project': {
          'key': params[:project_key]
        },
        'issuetype': {
          'id': 10002
        },
        'summary': 'Feedback on specifications, submitted by ' + params[:name] \
            + ' (' + params[:encoded_email] + ')',
        'description': {
          'type': 'doc',
          'version': 1,
          'content': [
            {
              'type': 'paragraph',
              'content': [
                {
                  'text': params[:name] + ' submitted the following feedback for page: ' \
                      + params[:issue_page] + '. ' + params[:issue],
                  'type': 'text'
                }
              ]
            }
          ]
        }
      }
    }
                   .to_json

    response = http.request(request)
    response_json = JSON.parse(response.body)

    respond_to do |format|
      format.json { render(json: { data: response_json }, status: :ok) }
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
