# frozen_string_literal: true

class Opportunity < ApplicationRecord
  include Auditable

  attribute :opportunity_status_type, :string
  enum opportunity_status_type: {
    CLOSED: 'CLOSED',
    OPEN: 'OPEN',
    UPCOMING: 'UPCOMING'
  }

  attribute :opportunity_type_type, :string
  enum opportunity_type_type: {
    BID: 'BID',
    TENDER: 'TENDER',
    INNOVATION: 'INNOVATION',
    BUILDING_BLOCK: 'BUILDING BLOCK',
    OTHER: 'OTHER'
  }

  has_and_belongs_to_many :sectors,
                          dependent: :delete_all,
                          join_table: :opportunities_sectors,
                          after_add: :association_add,
                          before_remove: :association_remove

  has_and_belongs_to_many :countries,
                          dependent: :delete_all,
                          join_table: :opportunities_countries,
                          after_add: :association_add,
                          before_remove: :association_remove

  has_and_belongs_to_many :organizations,
                          dependent: :delete_all,
                          join_table: :opportunities_organizations,
                          after_add: :association_add,
                          before_remove: :association_remove

  has_and_belongs_to_many :building_blocks,
                          dependent: :delete_all,
                          join_table: :opportunities_building_blocks,
                          after_add: :association_add,
                          before_remove: :association_remove

  has_and_belongs_to_many :use_cases,
                          dependent: :delete_all,
                          join_table: :opportunities_use_cases,
                          after_add: :association_add,
                          before_remove: :association_remove

  belongs_to(:origin)

  validates :name, presence: true, length: { maximum: 300 }

  scope :name_contains, ->(name) { where('LOWER(opportunities.name) like LOWER(?)', "%#{name}%") }
  scope :name_and_slug_search, -> (name, slug) { where('opportunities.name = ? OR opportunities.slug = ?', name, slug) }

  amoeba do
    enable

    exclude_association :building_blocks
    exclude_association :organizations
    exclude_association :use_cases
  end

  def sync_record(copy_of_opportunity)
    ActiveRecord::Base.transaction do
      update!(copy_of_opportunity.attributes.except('id', 'created_at', 'updated_at'))
    end
  end

  def image_file
    if File.exist?(File.join('public', 'assets', 'opportunities', "#{slug}.png"))
      "/assets/opportunities/#{slug}.png"
    else
      '/assets/opportunities/opportunity-placeholder.png'
    end
  end

  def sectors_localized
    sectors&.where('locale = ?', I18n.locale)&.order('name ASC')
  end

  def countries_ordered
    countries&.order('name ASC')
  end

  def self.order_by_status
    order(
      Arel.sql(
        "CASE
          WHEN opportunity_status = 'CLOSED' THEN '3'
          WHEN opportunity_status = 'OPEN' THEN '1'
          WHEN opportunity_status = 'UPCOMING' THEN '2'
        END"
      )
    )
  end

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end

  def self_url(options = {})
    if options[:api_path].present?
      return "#{options[:api_path]}/govstack_opportunities/#{slug}" if options[:govstack_path].present?
      return "#{options[:api_path]}/opportunities/#{slug}" unless options[:govstack_path].present?
    end
    return options[:item_path] if options[:item_path].present?
    return "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/opportunities" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    return options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    if options[:item_path].present?
      return options[:item_path].sub("/govstack_opportunities/#{slug}", '') if options[:govstack_path].present?
      return options[:item_path].sub("/opportunities/#{slug}", '') unless options[:govstack_path].present?
    end

    if options[:collection_path].present?
      return options[:collection_path].sub('/govstack_opportunities', '') if options[:govstack_path].present?
      return options[:collection_path].sub('/opportunities', '') unless options[:govstack_path].present?
    end
  end

  def govstack_path(options = {})
    options[:govstack_path]
  end

  def as_json(options = {})
    json = super(options)
    if options[:include_relationships].present?
      child_options = { api_path: api_path(options) }
      json['sectors'] = sectors.as_json(child_options.merge({ only: %i[name slug locale] }))
      json['countries'] = countries.as_json(child_options.merge({ only: %i[name slug] }))
    end
    json['self_url'] = self_url(options) if options[:collection_path].present? || options[:api_path].present?
    json['collection_url'] = collection_url(options) if options[:item_path].present?
    json
  end

  def self.to_csv
    attributes = %w[id name slug description products workflows]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |p|
        workflows = p.workflows
                     .map(&:name)
                     .join('; ')
        products = p.products
                    .map(&:name)
                    .join('; ')

        csv << [p.id, p.name, p.slug, p.description, products, workflows]
      end
    end
  end

  def self.serialization_options
    {
      except: %i[id origin_id created_at updated_at description]
    }
  end
end
