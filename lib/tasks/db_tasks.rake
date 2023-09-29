# frozen_string_literal: true

require 'modules/track'
include Modules::Track

namespace :db do
  desc 'returns appropriate exit code whether db exists or not'
  task :run_if_no_db do
    Rake::Task['environment'].invoke
    ActiveRecord::Base.connection
  rescue StandardError
    exit(0)
  else
    exit(1)
  end

  desc 'Dumps the database to db/backup/APP_NAME.dump'
  task backup: :environment do
    task_name = 'Database Backup'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)
    cmd = nil
    with_config do |app, host, db, user, pass, port|
      cmd = "export PGPASSWORD='#{pass}' && pg_dump --host #{host} --username #{user} -p #{port} " \
            "       --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/backups/#{app}.dump"
    end
    return_value = system(cmd)
    if return_value
      tracking_task_finish(task_name)
    end
  end

  desc 'Restores the database dump at db/APP_NAME.dump.'
  task restore: :environment do
    cmd = nil
    with_config do |app, host, db, user, pass, port|
      cmd = "export PGPASSWORD='#{pass}' && pg_restore --verbose --host #{host} --username #{user} -p #{port} " \
            "       --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/backups/#{app}.dump"
    end
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    system(cmd)
  end

  desc 'Creates a database the first time the app is run - from db/APP_NAME_public.dump.'
  task create_db_with_public_data: :environment do
    cmd = nil
    with_config do |app, host, db, user, pass, port|
      cmd = "export PGPASSWORD='#{pass}' && pg_restore --verbose --host #{host} --username #{user} -p #{port} " \
            "       --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/backups/#{app}_public.dump"
    end
    Rake::Task['db:create'].invoke
    system(cmd)
  end

  desc 'Export database minus proprietary data - this export can be provided to other customers'
  task dump_public_db: :environment do
    cmd = nil
    with_config do |app, host, db, user, pass, port|
      cmd = "export PGPASSWORD='#{pass}' && pg_dump --host #{host} --username #{user} -p #{port} " \
            '       --exclude-table-data=users ' \
            '       --exclude-table-data=users_products ' \
            '       --exclude-table-data=sessions ' \
            '       --exclude-table-data=contacts ' \
            '       --exclude-table-data=organizations_contacts ' \
            '       --verbose --clean --no-owner --no-acl ' \
            "       --format=c #{db} > #{Rails.root}/db/backups/#{app}_public.dump"
    end
    system(cmd)
  end

  desc 'Send backup email to admin users that have receive_backup selected'
  task send_backup_emails: :environment do
    task_name = 'Database Backup Email'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    with_config do |_app, _host, _db, _user, _pass|
      users = User.where(receive_backup: true)
      users.each do |user|
        RakeMailer.database_backup(user.email, 'Database dump file').deliver_now
      end
    end

    tracking_task_finish(task_name)
  end

  desc 'Clean unused expired sessions.'
  task clear_expired_sessions: :environment do
    task_name = 'Clear Expired Session'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    sql = "DELETE FROM sessions WHERE updated_at < (NOW() - INTERVAL '2 DAY');"
    ActiveRecord::Base.connection.execute(sql)

    tracking_task_finish(task_name)
  end

  private

  def with_config
    yield Rails.application.class.module_parent_name.underscore,
      ActiveRecord::Base.connection_db_config.configuration_hash[:host],
      ActiveRecord::Base.connection_db_config.configuration_hash[:database],
      ActiveRecord::Base.connection_db_config.configuration_hash[:username],
      ActiveRecord::Base.connection_db_config.configuration_hash[:password],
      ActiveRecord::Base.connection_db_config.configuration_hash[:port]
  end
end
