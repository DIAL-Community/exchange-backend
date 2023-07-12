# frozen_string_literal: true

require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/file_token_store'
require 'google/apis/sheets_v4'

module Modules
  module GoogleApis
    APPLICATION_NAME = 'DIAL Catalog of Digital Solutions'

    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
    TOKEN_PATH = Rails.root.join('lib/assets/token.yaml').freeze
    CREDENTIALS_PATH = Rails.root.join('lib/assets/credentials.json').freeze

    def authorize_api
      # https://github.com/googleapis/google-auth-library-ruby/blob/main/README.md
      scope = ['https://www.googleapis.com/auth/spreadsheets.readonly']
      client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)

      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)
      if credentials.nil?
        url = authorizer.get_authorization_url(base_url: OOB_URI)
        puts 'Open the following URL in the browser and enter the resulting code after authorization: ' + url
        # TODO: Need to swap get with the output of the URL above.
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id:, code:, base_url: OOB_URI
        )
      end
      credentials
    end

    def read_spreadsheet(spreadsheet_id, range)
      # Initialize the API
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = authorize_api

      service.get_spreadsheet_values(spreadsheet_id, range)
    end
  end
end
