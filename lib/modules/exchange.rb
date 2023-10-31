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

        tenant_list = ExchangeTenant.pluck(:tenant_name)

        curr_host = URI.parse(request.referrer).host
        requested_tenant = ExchangeTenant.where(:domain => curr_host).first
        tenant_name = requested_tenant.nil? ? 'public' : requested_tenant.tenant_name
      end
    end
  end
end