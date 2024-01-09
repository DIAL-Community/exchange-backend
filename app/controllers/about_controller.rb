# frozen_string_literal: true

class AboutController < ApplicationController
  def healthcheck
    sys_command = "PGPASSWORD='#{ENV['DATABASE_PASSWORD']}' psql -h #{ENV['DATABASE_HOST']} " \
                  "-U #{ENV['DATABASE_USER']} -d #{ENV['DATABASE_NAME']} -p #{ENV['DATABASE_PORT']} -c '\\q'"

    db_health = system(sys_command)

    render(json: { "webapp": true, "psql": db_health })
  end

  def tenant
    render(json: {
      "tenant": Apartment::Tenant.current,
      "hostname": URI.parse(request.referrer).host
    })
  end
end
