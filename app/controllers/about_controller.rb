# frozen_string_literal: true

class AboutController < ApplicationController
  def healthcheck
    sys_command = "PGPASSWORD='#{ENV['DATABASE_PASSWORD']}' psql -h #{ENV['DATABASE_HOST']} " \
                  "-U #{ENV['DATABASE_USER']} -d #{ENV['DATABASE_NAME']} -p #{ENV['DATABASE_PORT']} -c '\\q'"

    db_health = system(sys_command)

    render(json: { "webapp": true, "psql": db_health })
  end

  def tenant
    current_tenant = ExchangeTenant.find_by(tenant_name: Apartment::Tenant.current)
    render(json: {
      "hostname": request.referrer.blank? ? 'default' : URI.parse(request.referrer).hostname,
      'secured': current_tenant.nil? ? false : !current_tenant.allow_unsecure_read,
      "tenant": current_tenant.nil? ? 'default' : current_tenant.tenant_name
    })
  end
end
