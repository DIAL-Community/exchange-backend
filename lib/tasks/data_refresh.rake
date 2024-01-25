# frozen_string_literal: true

namespace :data_refresh do
  desc 'Process dataset spreadsheet and populate the json file.'
  task refresh_slug: :environment do
    Rails.application.eager_load!

    classes = ActiveRecord::Base.descendants
    classes.each do |c|
      next if c.nil?
      next if c.name.include?('::') || c.name.include?('HABTM') || c.name.include?('InternalMetadata')
      next if c.table_name.nil? || c.table_name.blank?

      puts "Processing #{c.name} --> #{c.table_name}."
      records = c.all
      puts "  Processing #{records.size} records."
    end
  end
end
