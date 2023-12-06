# frozen_string_literal: true
require 'apartment/elevators/generic'

module Apartment
  module Elevators
    #   Provides a rack based tenant switching solution based on subdomains
    #   Assumes that tenant name should match subdomain
    #
    class Exchange < Generic
      # @return {String} - The tenant to switch to
      def parse_tenant_name(request)
        # request is an instance of Rack::Request

        curr_host = URI.parse(request.referrer).host unless request.referrer.nil?
        # The following is for the next-auth pages, which do not send origin or referer headers.
        # We add the tenant manually before making the call
        curr_host = request.env["HTTP_X_TENANT_ID"].split(':')[0] if request.referrer.nil? &&
          !request.env["HTTP_X_TENANT_ID"].nil?

        # The following is for confirmation token emails which will not have a referrer or
        # X-Tenant-ID added
        curr_host = request.env["HTTP_HOST"].split(':')[0] if request.referrer.nil? &&
          request.env["HTTP_X_TENANT_ID"].nil?

        requested_tenant = ExchangeTenant.where(domain: curr_host).first
        requested_tenant.nil? ? tenant_name = 'public' : tenant_name = requested_tenant.tenant_name
        tenant_name
      end
    end
  end
end
