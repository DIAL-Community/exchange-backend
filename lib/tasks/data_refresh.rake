# frozen_string_literal: true

namespace :data_refresh do
  desc 'Process dataset spreadsheet and populate the json file.'
  task refresh_slug: :environment do
    Rails.application.eager_load!

    classes = ActiveRecord::Base.descendants
    classes.each do |c|
      next if c.nil?
      next if c.name.include?('ApplicationRecord') || c.name.include?('DialSpreadsheetData')
      next if c.name.include?('::') || c.name.include?('HABTM') || c.name.include?('InternalMetadata')
      next if c.table_name.nil? || c.table_name.blank?

      puts "Processing class: #{c.name}, table: #{c.table_name}."

      have_slug = c.column_names.include?('slug')
      unless have_slug
        puts "  Skipping #{c.name} as it does not have a slug."
        next
      end

      records = c.where('slug LIKE ?', '%\_%')
      puts "  Found #{records.size} record(s) to process."
      records.each do |record|
        current_slug = record.slug
        if record.respond_to?(:generate_slug)
          record.slug = record.generate_slug
        else
          record.slug = reslug_em(record.name, 64)
        end

        if c.where(slug: record.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = c.slug_simple_starts_with(record.slug)
                             .order(slug: :desc)
                             .first

          record.slug = record.slug + generate_offset(first_duplicate)
        end

        if record.save
          puts "  Updated from #{current_slug} to #{record.slug}."
        end
      end
    end
  end
end