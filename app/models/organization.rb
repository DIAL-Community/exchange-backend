# frozen_string_literal: true

require('csv')

class Organization < ApplicationRecord
  include Auditable

  enum org_type: { endorser: 'endorser', mni: 'mni', product: 'product' }, _suffix: true
  enum endorser_levels: { NONE: 'none', GOLD: 'gold', SILVER: 'silver', BRONZE: 'bronze' }

  attr_accessor :organization_description

  has_and_belongs_to_many(
    :datasets,
    join_table: :organizations_datasets,
    after_add: :association_add,
    before_remove: :association_remove
  )

  has_and_belongs_to_many(
    :countries,
    join_table: :organizations_countries,
    after_add: :association_add,
    before_remove: :association_remove
  )

  has_and_belongs_to_many(
    :states,
    join_table: :organizations_states,
    after_add: :association_add,
    before_remove: :association_remove
  )

  has_and_belongs_to_many(
    :sectors,
    join_table: :organizations_sectors,
    after_add: :association_add,
    before_remove: :association_remove
  )

  has_and_belongs_to_many(
    :projects,
    join_table: :projects_organizations,
    dependent: :delete_all,
    after_add: :association_add,
    before_remove: :association_remove
  )

  has_many(
    :aggregator_capabilities,
    join_table: :aggregator_capabilities,
    foreign_key: 'aggregator_id',
    dependent: :delete_all,
    after_add: :association_add,
    before_remove: :association_remove
  )

  has_many(
    :organizations_contacts,
    after_add: :association_add,
    before_remove: :association_remove,
    dependent: :delete_all
  )

  has_many(
    :contacts,
    through: :organizations_contacts,
    after_add: :association_add,
    before_remove: :association_remove,
    dependent: :delete_all
  )

  has_and_belongs_to_many(
    :resources,
    after_add: :association_add,
    before_remove: :association_remove,
    dependent: :delete_all
  )

  has_and_belongs_to_many :opportunities, join_table: :opportunities_organizations

  has_many :organizations_products, after_add: :association_add, before_remove: :association_remove
  has_many :products, through: :organizations_products,
                      after_add: :association_add, before_remove: :association_remove

  has_many :organization_descriptions, dependent: :destroy
  has_many :offices, dependent: :destroy, after_add: :association_add, before_remove: :association_remove

  validates :name, presence: true, length: { maximum: 300 }

  scope :name_contains, ->(name) { where('LOWER(organizations.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(organizations.slug) like LOWER(?)', "#{slug}\\_%") }

  def image_file
    if File.exist?(File.join('public', 'assets', 'organizations', "#{slug}.png"))
      "/assets/organizations/#{slug}.png"
    else
      '/assets/organizations/org_placeholder.png'
    end
  end

  def sectors_localized
    sectors.where('locale = ?', I18n.locale)
  end

  def organization_description_localized
    description = organization_descriptions
                  .find_by(locale: I18n.locale)
    if description.nil?
      description = organization_descriptions
                    .find_by(locale: 'en')
    end
    description
  end

  def organization_countries_ordered
    countries&.order('name ASC')
  end

  # overridden
  def to_param
    slug
  end

  def self.first_duplicate(name, slug)
    find_by('name = ? OR slug = ? OR ? = ANY(aliases)', name, slug, name)
  end

  def self.to_csv
    attributes = %w[id name slug aliases when_endorsed website is_endorser is_mni countries offices sectors]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |o|
        countries = o.countries
                     .map(&:name)
                     .join('; ')
        offices = o.offices
                   .map(&:city)
                   .join('; ')

        sectors = o.sectors_localized
                   .map(&:name)
                   .join('; ')

        csv << [o.id, o.name, o.slug, o.aliases, o.when_endorsed, o.website, o.is_endorser, o.is_mni, countries,
                offices, sectors]
      end
    end
  end

  def self_url(options = {})
    return "#{options[:api_path]}/organizations/#{slug}" if options[:api_path].present?
    return options[:item_path] if options[:item_path].present?
    return "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/organizations" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    return options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    return options[:item_path].sub("/organizations/#{slug}", '') if options[:item_path].present?
    return options[:collection_path].sub('/organizations', '') if options[:collection_path].present?
  end

  def as_json(options = {})
    json = super(options)
    if options[:include_relationships].present?
      json['countries'] = countries.as_json({ only: %i[name slug code], api_path: api_path(options) })
      json['offices'] = offices.as_json({ only: %i[name slug city], api_path: api_path(options) })
      json['products'] = products.as_json({ only: %i[name slug website], api_path: api_path(options) })
    end
    json['self_url'] = self_url(options) if options[:collection_path].present? || options[:api_path].present?
    json['collection_url'] = collection_url(options) if options[:item_path].present?
    json
  end

  def self.serialization_options
    {
      except: %i[id created_at updated_at],
      include: {
        countries: { only: %i[name slug code] },
        offices: {
          only: %i[name city],
          include: {
            country: { only: %i[name slug code] },
            region: { only: [:name] }
          }
        },
        products: { only: %i[name slug] },
        projects: { only: %i[name slug] }
      }
    }
  end
end
