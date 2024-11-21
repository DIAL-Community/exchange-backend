# frozen_string_literal: true

class AboutController < ApplicationController
  def healthcheck
    sys_command = "PGPASSWORD='#{ENV['DATABASE_PASSWORD']}' psql -h #{ENV['DATABASE_HOST']} " \
                  "-U #{ENV['DATABASE_USER']} -d #{ENV['DATABASE_NAME']} -p #{ENV['DATABASE_PORT']} -c '\\q'"

    db_health = system(sys_command)

    render(json: { "webapp": true, "psql": db_health })
  end

  def tenant
    # Allow for the case of a tenant that uses the default database
    default_tenants = [
      { "hostname": "dpi.localhost", "tenant_name": DPI_TENANT_NAME },
      { "hostname": "dpi.dial.global", "tenant_name": DPI_TENANT_NAME },
      { "hostname": "resource.dial.global", "tenant_name": DPI_TENANT_NAME },
      { "hostname": "dpi.dial.community", "tenant_name": DPI_TENANT_NAME }
    ]

    default_tenant = default_tenants.find { |t| t[:hostname] == URI.parse(request.referrer).hostname }
    unless default_tenant.nil?
      render(json: {
        "hostname": URI.parse(request.referrer).hostname,
        'secured': false,
        "tenant": default_tenant[:tenant_name]
      })
      return
    end

    current_tenant = ExchangeTenant.find_by(tenant_name: Apartment::Tenant.current)
    render(json: {
      "hostname": request.referrer.blank? ? 'public' : URI.parse(request.referrer).hostname,
      'secured': current_tenant.nil? ? false : !current_tenant.allow_unsecured_read,
      "tenant": current_tenant.nil? ? 'public' : current_tenant.tenant_name
    })
  end

  def tenants
    render(json: { "tenants": ExchangeTenant.distinct.pluck(:tenant_name) })
  end
end
