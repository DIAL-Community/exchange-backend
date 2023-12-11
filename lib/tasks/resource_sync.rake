# frozen_string_literal: true

require 'faraday'
require 'json'
require 'nokogiri'
require 'tempfile'
require 'modules/slugger'

namespace :resources_sync do
  desc 'Sync DIAL resources data with wordpress API.'
  task sync_dial_resources: :environment do
    task_name = 'Sync DIAL Resources'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    # Some of the resources' content is not returned by the wordpress API, so we need to
    # fetch them from the wordpress site and then parse it with nokogiri and then  sync
    # them with the database.
    # https://stackoverflow.com/q/43381617

    # Fetch all resources from wordpress API
    current_page = 1
    wp_api_base = 'https://dial.global/wp-json/wp/v2/posts'

    still_seeing_resources = true
    while still_seeing_resources
      wp_page_query = "?page=#{current_page}"
      response = Faraday.get("#{wp_api_base}#{wp_page_query}")
      response_body = JSON.parse(response.body)

      # Last page of the /wp/v2/posts API:
      # {
      #   "code": "rest_post_invalid_page_number",
      #   "message": "The page number requested is larger than the number of pages available.",
      #   "data": {
      #     "status": 400
      #   }
      # }
      #
      # Page with data will have structure like this:
      # [
      #   {
      #     "id": 1641
      #     ... more post's fields
      #   },
      #   {
      #     "id": 1642
      #     ... more post's fields
      #   },
      # ]

      if response_body.is_a?(Hash)
        still_seeing_resources = false
      else
        response_body.each do |post|
          puts "Processing resource: #{post['id']}"
        end
      end

      current_page += 1
    end

    tracking_task_finish(task_name)
  end
end
