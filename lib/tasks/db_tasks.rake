# frozen_string_literal: true
require 'faker'
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

  desc 'Dumps specific database schema to db/backup/{app-name}-{schema-name}.dump'
  task :backup_schema, [:schema_name] => :environment do |_task, args|
    task_name = 'Database Schema Backup'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    schema_name = args[:schema_name]

    cmd = nil
    with_config do |app, host, db, user, pass, port|
      cmd = " export PGPASSWORD='#{pass}' && " \
            " pg_dump --verbose --clean --host #{host} --username #{user} -p #{port} -n #{schema_name} " \
            " --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/backups/#{app}-#{schema_name}.dump"
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

  desc 'Restores the schema dump at db/{app-name}-{schema-name}.dump.'
  task :restore_schema, [:schema_name] => :environment do |_task, args|
    task_name = 'Database Schema Backup'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    schema_name = args[:schema_name]

    cmd = nil
    with_config do |app, host, db, user, pass, port|
      cmd = " export PGPASSWORD='#{pass}' && " \
            " pg_restore --verbose --clean --host #{host} --username #{user} -p #{port} -n #{schema_name} " \
            " --no-owner --no-acl --dbname #{db} #{Rails.root}/db/backups/#{app}-#{schema_name}.dump"
    end

    return_value = system(cmd)
    if return_value
      tracking_task_finish(task_name)
    end
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

  desc 'Clean audit records if they are older than 90 days.'
  task clean_older_audits: :environment do
    task_name = 'Clear Older Audit Records'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    Audit.where('created_at < ?', 90.days.ago).destroy_all
    UserEvent.where('created_at < ?', 90.days.ago).destroy_all

    tracking_task_finish(task_name)
  end

  desc 'Randomize the email address for development.'
  task randomize_email_address: :environment do
    task_name = 'Randomize Email Address'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    Contact.all.each do |contact|
      puts "Processing contact #{contact.email}..."

      current_email = contact.email

      fake_name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
      fake_username = fake_name.split(' ').map(&:downcase).join('.')
      fake_email = fake_username + "@example.com"

      execution_result = contact.update(name: fake_name, email: fake_email)
      if execution_result
        puts "  Updated contact with fake name: #{fake_name} and fake email: #{fake_email}."
      end

      current_user = User.find_by(email: current_email)
      unless current_user.nil?
        current_user.email = fake_email
        current_user.username = fake_username
        current_user.skip_reconfirmation!
        execution_result = current_user.save
        if execution_result
          puts "  Updated user with fake email: #{fake_email} and fake username: #{fake_username}."
        end
      end

      current_author = Author.find_by(email: current_email)
      unless current_author.nil?
        current_author.name = fake_name
        current_author.email = fake_email
        execution_result = current_author.save
        if execution_result
          puts "  Updated author with fake email: #{fake_email} and fake username: #{fake_username}."
        end
      end

      current_candidate_dataset = CandidateDataset.find_by(submitter_email: current_email)
      unless current_candidate_dataset.nil?
        current_candidate_dataset.submitter_email = fake_email
        execution_result = current_candidate_dataset.save
        if execution_result
          puts "  Updated author with fake email: #{fake_email} and fake username: #{fake_username}."
        end
      end

      current_candidate_product = CandidateProduct.find_by(submitter_email: current_email)
      unless current_candidate_product.nil?
        current_candidate_product.submitter_email = fake_email
        execution_result = current_candidate_product.save
        if execution_result
          puts "  Updated author with fake email: #{fake_email} and fake username: #{fake_username}."
        end
      end

      current_candidate_role = CandidateRole.find_by(email: current_email)
      unless current_candidate_role.nil?
        current_candidate_role.email = fake_email
        execution_result = current_candidate_role.save
        if execution_result
          puts "  Updated author with fake email: #{fake_email} and fake username: #{fake_username}."
        end
      end

      current_opportunity = Opportunity.find_by(contact_email: current_email)
      unless current_opportunity.nil?
        current_opportunity.contact_name = fake_name
        current_opportunity.contact_email = fake_email
        execution_result = current_opportunity.save
        if execution_result
          puts "  Updated author with fake email: #{fake_email} and fake username: #{fake_username}."
        end
      end

      current_user_event = UserEvent.find_by(email: current_email)
      next if current_user_event.nil?

      current_user_event.email = fake_email
      execution_result = current_user_event.save
      if execution_result
        puts "  Updated author with fake email: #{fake_email} and fake username: #{fake_username}."
      end
    end

    User.all.each do |user|
      puts "Processing user #{user.email}..."
      current_contact = Contact.find_by(email: user.email)
      # Skip if we found contact because we already updated updated it before.
      next unless current_contact.nil?

      fake_name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
      fake_username = fake_name.split(' ').map(&:downcase).join('.')
      fake_email = fake_username + "@example.com"

      user.email = fake_email
      user.username = fake_username
      user.skip_reconfirmation!
      execution_result = user.save
      if execution_result
        puts "  Updated user with fake email: #{fake_email} and fake username: #{fake_username}."
      end
    end

    Author.all.each do |author|
      puts "Processing user #{author.email}..."
      current_contact = Contact.find_by(email: author.email)
      # Skip if we found contact because we already updated it before.
      next unless current_contact.nil?

      fake_name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
      fake_username = fake_name.split(' ').map(&:downcase).join('.')
      fake_email = fake_username + "@example.com"

      author.name = fake_name
      author.email = fake_email
      execution_result = author.save
      if execution_result
        puts "  Updated author with fake email: #{fake_email} and fake username: #{fake_username}."
      end
    end

    CandidateDataset.all.each do |candidate_dataset|
      puts "Processing candidate dataset #{candidate_dataset.submitter_email}..."
      current_contact = Contact.find_by(email: candidate_dataset.submitter_email)
      # Skip if we found contact because we already updated it before.
      next unless current_contact.nil?

      fake_name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
      fake_username = fake_name.split(' ').map(&:downcase).join('.')
      fake_email = fake_username + "@example.com"

      candidate_dataset.submitter_email = fake_email
      execution_result = candidate_dataset.save
      if execution_result
        puts "  Updated candidate dataset with fake submitter email: #{fake_email}."
      end
    end

    CandidateProduct.all.each do |candidate_product|
      puts "Processing candidate product #{candidate_product.submitter_email}..."
      current_contact = Contact.find_by(email: candidate_product.submitter_email)
      # Skip if we found contact because we already updated it before.
      next unless current_contact.nil?

      fake_name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
      fake_username = fake_name.split(' ').map(&:downcase).join('.')
      fake_email = fake_username + "@example.com"

      candidate_product.submitter_email = fake_email
      execution_result = candidate_product.save
      if execution_result
        puts "  Updated candidate product with fake submitter email: #{fake_email}."
      end
    end

    CandidateRole.all.each do |candidate_role|
      puts "Processing candidate role #{candidate_role.email}..."
      current_contact = Contact.find_by(email: candidate_role.email)
      # Skip if we found contact because we already updated it before.
      next unless current_contact.nil?

      fake_name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
      fake_username = fake_name.split(' ').map(&:downcase).join('.')
      fake_email = fake_username + "@example.com"

      candidate_role.email = fake_email
      execution_result = candidate_role.save
      if execution_result
        puts "  Updated candidate role with fake submitter email: #{fake_email}."
      end
    end

    Opportunity.all.each do |opportunity|
      puts "Processing opportunity #{opportunity.contact_email}..."
      current_contact = Contact.find_by(email: opportunity.contact_email)
      # Skip if we found contact because we already updated it before.
      next unless current_contact.nil?

      fake_name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
      fake_username = fake_name.split(' ').map(&:downcase).join('.')
      fake_email = fake_username + "@example.com"

      opportunity.contact_name = fake_name
      opportunity.contact_email = fake_email
      execution_result = opportunity.save
      if execution_result
        puts "  Updated opportunity with fake email: #{fake_email} and fake username: #{fake_username}."
      end
    end

    UserEvent.where.not(email: nil).each do |user_event|
      puts "Processing user #{user_event.email}..."
      current_contact = Contact.find_by(email: user_event.email)
      # Skip if we found contact because we already updated it before.
      next unless current_contact.nil?

      fake_name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
      fake_username = fake_name.split(' ').map(&:downcase).join('.')
      fake_email = fake_username + "@example.com"

      user_event.email = fake_email
      execution_result = user_event.save
      if execution_result
        puts "  Updated user event with fake email: #{fake_email}."
      end
    end

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
