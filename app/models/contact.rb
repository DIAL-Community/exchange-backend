# frozen_string_literal: true

class Contact < ApplicationRecord
  has_many :organization_contacts
  has_many :organizations, through: :organization_contacts

  validates :name, presence: true, length: { maximum: 300 }

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end

  def self_url(options = {})
    return "#{options[:api_path]}/contacts/#{slug}" if options[:api_path].present?
    return options[:item_path] if options[:item_path].present?
    "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/contacts" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    return options[:item_path].sub("/contacts/#{slug}", '') if options[:item_path].present?
    options[:collection_path].sub('/contacts', '') if options[:collection_path].present?
  end

  def as_json(options = {})
    json = super(options)
    if options[:include_relationships].present?
      json['organizations'] = organizations.as_json({ only: %i[name slug website], api_path: api_path(options) })
    end
    json['self_url'] = self_url(options) if options[:collection_path].present? || options[:api_path].present?
    json['collection_url'] = collection_url(options) if options[:item_path].present?
    json
  end

  def self.serialization_options
    {
      include: %i[name email title]
    }
  end
end
