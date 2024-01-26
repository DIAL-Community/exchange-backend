# frozen_string_literal: true

class Office < ApplicationRecord
  include Modules::Slugger

  belongs_to :organization
  belongs_to :country
  belongs_to :province

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end

  def self_url(options = {})
    record = City.find_by(name: city)
    return "#{options[:api_path]}/cities/" if options[:api_path].present? && record.nil?
    return "#{options[:api_path]}/cities/#{record.slug}" if options[:api_path].present?
  end

  def as_json(options = {})
    json = super(options)
    json['self_url'] = self_url(options)
    json
  end
end
