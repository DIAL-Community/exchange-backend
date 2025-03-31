# frozen_string_literal: true

namespace :adli_processor do
  desc 'Read files for contacts and try to find matching contacts in the database.'
  task match_contact_with_asset: :environment do
    contact_assets_dir = './public/assets/contacts/'
    Dir.glob("#{contact_assets_dir}*.[jp]*") do |filename|
      puts "Processing #{filename}..."
      # file_extension = File.extname(filename)
      contact_name = filename.gsub(contact_assets_dir, '')

      existing_contact = nil
      Contact.all.each do |contact|
        first_name, last_name = contact.name.split(' ')
        next if first_name.nil? || last_name.nil?

        if contact_name.include?(first_name) && contact_name.include?(last_name)
          existing_contact = contact
          break
        end
      end

      if existing_contact.nil?
        puts "  Contact #{contact_name} not found in the database."
      else
        puts "  Contact #{contact_name} found in the database. Renaming file..."
        File.rename(filename, contact_assets_dir + existing_contact.slug + '.jpg')
      end
    end
  end

  desc 'Update ADLI password using the first part of their email address'
  task update_adli_password: :environment do
    workbook = Roo::Spreadsheet.open('./data/spreadsheet/ADLI-Welcome-Questions.xlsx')
    workbook.default_sheet = workbook.sheets.first

    worksheet_headers = workbook.row(1).map { |header| header.gsub(/\A\p{Space}*|\p{Space}*\z/, '') }

    2.upto(workbook.last_row) do |row_count|
      current_row = workbook.row(row_count)
      current_row_sanitized = current_row.map { |cell| cell.to_s.gsub(/\A\p{Space}*|\p{Space}*\z/, '') }
      current_row_data = Hash[worksheet_headers.zip(current_row_sanitized)]

      email_address = current_row_data['Email address:'].downcase
      puts "Processing row with email address: #{email_address}."

      existing_user = User.find_by(email: email_address)
      next if existing_user.nil?

      updated_password = email_address.split('@').first
      saved = existing_user.reset_password(updated_password, updated_password)
      if saved
        puts "  Successfully updated password for user: #{existing_user.id}:#{existing_user.email}."
      end
    end
  end

  desc 'Read ADLI questionnaire spreadsheet answers and build user & contact records.'
  task parse_adli_file: :environment do
    workbook = Roo::Spreadsheet.open('./data/spreadsheet/ADLI-Welcome-Questions.xlsx')
    workbook.default_sheet = workbook.sheets.first

    worksheet_headers = workbook.row(1).map { |header| header.gsub(/\A\p{Space}*|\p{Space}*\z/, '') }
    puts "Worksheet headers: #{worksheet_headers.inspect}."

    2.upto(workbook.last_row) do |row_count|
      current_row = workbook.row(row_count)
      current_row_sanitized = current_row.map { |cell| cell.to_s.gsub(/\A\p{Space}*|\p{Space}*\z/, '') }
      current_row_data = Hash[worksheet_headers.zip(current_row_sanitized)]

      email_address = current_row_data['Email address:'].downcase
      puts "Processing row with email address: #{email_address}."

      existing_user = User.find_by(email: email_address)
      existing_contact = Contact.find_by(email: email_address)

      successful_operation = false
      ActiveRecord::Base.transaction do
        if existing_user.nil?
          puts "  Using generated password: #{generate_password(email_address.split('@').first)}."
          existing_user = User.new(
            email: email_address,
            username: email_address,
            password: generate_password(email_address.split('@').first),
            password_confirmation: generate_password(email_address.split('@').first),
            confirmed_at: Time.now
          )
          existing_user.save!
        end

        # Ensure user will be assigned the 'adli_user' role.
        existing_user.roles << 'adli_user' if existing_user.roles.exclude?('adli_user')
        existing_user.save!

        if existing_contact.nil?
          existing_contact = Contact.new(email: email_address, slug: reslug_em(email_address))
        end

        if existing_contact.name != current_row_data['Full Name:'] ||
          existing_contact.email != current_row_data['Email address:']
          existing_contact.slug = reslug_em(email_address)
        end

        existing_contact.source = DPI_TENANT_NAME
        existing_contact.name = current_row_data['Full Name:'].titleize
        existing_contact.title = current_row_data['Designation:']

        linked_profile_url = current_row_data['LinkedIn Profile Link:']
        update_social_networking_service(existing_contact, 'linkedin', linked_profile_url)

        phone_number_title = 'If you consent to be added to a Whatsapp Group with fellow cohort members, please '\
          'share your mobile number (with country code):'
        phone_number_value = current_row_data[phone_number_title]
        update_social_networking_service(existing_contact, 'phone', phone_number_value)

        current_organization = current_row_data['Organization:']
        unless current_organization.nil? || current_organization.empty?
          organization_found = false
          Organization.all.each do |organization|
            next unless organization.name.downcase.include?(current_organization.downcase)

            organization_found = true
            update_extra_attribute(existing_contact, 'organization', organization.name)
            update_extra_attribute(existing_contact, 'organization-slug', organization.slug)
          end

          unless organization_found
            update_extra_attribute(existing_contact, 'organization', current_organization)
            update_extra_attribute(existing_contact, 'organization-slug', nil)
          end
        end

        focus_country = current_row_data['Country or Region of Focus:']
        unless focus_country.nil? || focus_country.empty?
          country_found = false
          Country.all.each do |country|
            next unless focus_country.downcase.include?(country.name.downcase)

            country_found = true
            update_extra_attribute(existing_contact, 'country', country.name)
            update_extra_attribute(existing_contact, 'country-slug', country.code)
          end

          unless country_found
            update_extra_attribute(existing_contact, 'country', focus_country)
            update_extra_attribute(existing_contact, 'country-slug', nil)
          end
        end

        consent_header_title = 'We are creating an ADLI Participant Directory on the DIAL Resource Hub website to ' \
          'profile each participant. This will be publicly viewable. Do you consent to your name, organization, ' \
          'designation, and'
        consent_value = current_row_data[consent_header_title]
        update_extra_attribute(existing_contact, 'consent', consent_value)

        existing_contact.save!
        successful_operation = true
      end

      if successful_operation
        puts "  Successfully created user: #{existing_user.id}:#{existing_user.email}."
        puts "  Associated contact record: #{existing_contact.id}:#{existing_contact.name}."
      end
    end
  end

  def update_extra_attribute(contact, extra_attribute_name, extra_attribute_value)
    extra_attribute_entry = {
      name: extra_attribute_name,
      value: extra_attribute_value
    }

    existing_entry_index = contact.extra_attributes.select { |e| e['name'] == extra_attribute_name }
    if existing_entry_index.nil?
      contact.extra_attributes << extra_attribute_entry
    else
      contact.extra_attributes[existing_entry_index] = extra_attribute_entry
    end
  end

  def update_social_networking_service(contact, sns_name, sns_value)
    return if sns_name == 'linkedin' && !sns_value.downcase.include?('linkedin')

    sns_entry = {
      name: sns_name,
      value: sns_value.strip
                      .sub(/^https?:\/\//i, '')
                      .sub(/^https?\/\/:/i, '')
                      .sub(/\/$/, '')
    }

    existing_entry_index = contact.social_networking_services.index { |sns| sns['name'] == sns_name }
    if existing_entry_index.nil?
      contact.social_networking_services << sns_entry
    else
      contact.social_networking_services[existing_entry_index] = sns_entry
    end
  end

  def generate_password(user_username)
    nato_phonetic_alphabet = {
      'A' => 'Alpha',
      'B' => 'Bravo',
      'C' => 'Charlie',
      'D' => 'Delta',
      'E' => 'Echo',
      'F' => 'Foxtrot',
      'G' => 'Golf',
      'H' => 'Hotel',
      'I' => 'India',
      'J' => 'Juliet',
      'K' => 'Kilo',
      'L' => 'Lima',
      'M' => 'Mike',
      'N' => 'November',
      'O' => 'Oscar',
      'P' => 'Papa',
      'Q' => 'Quebec',
      'R' => 'Romeo',
      'S' => 'Sierra',
      'T' => 'Tango',
      'U' => 'Uniform',
      'V' => 'Victor',
      'W' => 'Whiskey',
      'X' => 'X-ray',
      'Y' => 'Yankee',
      'Z' => 'Zulu'
    }

    random_passwords = []
    user_username[0..5].split("").each do |letter|
      random_passwords << nato_phonetic_alphabet[letter.upcase]
    end
    random_passwords.join(" ")
  end

  desc 'Migrate ADLI alumni information.'
  task migrate_adli_alumni: :environment do
    # The previous cohort doesn't have any years associated with it.
    adli_contacts = Contact.where(source: DPI_TENANT_NAME)
    adli_contacts.each do |adli_contact|
      next if adli_contact.extended_data.nil?

      extra_attributes = []
      adli_contact.extended_data.each do |extended_data|
        name = extended_data['key']
        value = extended_data['value']
        extra_attributes << {
          'name': name,
          'value': value
        }
      end

      years = adli_contact.extended_data.select { |e| e['key'] == 'years' }
      if years.nil? || years.empty?
        extra_attributes << {
          'name': 'adli-years',
          'value': [Date.current.year - 1]
        }
      end

      adli_contact.extra_attributes = extra_attributes
      if adli_contact.save
        puts "Migrated extended_data for #{adli_contact.name} to extra_attributes."
      end
    end
  end
end
