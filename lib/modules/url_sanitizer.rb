# frozen_string_literal: true

module Modules
  module UrlSanitizer
    # Strip protocol from url. We will use // on the front end to allow browser to pick
    # the protocol.
    def cleanup_url(maybe_url)
      cleaned_url = ''
      unless maybe_url.blank?
        cleaned_url = maybe_url.strip
                               .sub(/^https?:\/\//i, '')
                               .sub(/^https?\/\/:/i, '')
                               .sub(/\/$/, '')
      end
      cleaned_url
    end
  end
end
