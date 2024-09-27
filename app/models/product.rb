# frozen_string_literal: true

require 'csv'
require 'modules/maturity_sync'

class Product < ApplicationRecord
  include Auditable
  include Modules::MaturitySync

  attr_accessor :product_description

  has_many :product_indicators, dependent: :delete_all
  has_many :product_repositories, dependent: :delete_all
  has_many :product_descriptions, dependent: :delete_all

  has_many :product_classifications,
           dependent: :delete_all
  has_many :classifications,
           through: :product_classifications,
           dependent: :delete_all

  has_many :organization_products,
           dependent: :delete_all,
           after_add: :association_add,
           before_remove: :association_remove
  has_many :organizations,
           through: :organization_products,
           dependent: :delete_all,
           after_add: :association_add,
           before_remove: :association_remove

  has_many :product_sectors,
           dependent: :delete_all,
           after_add: :association_add,
           before_remove: :association_remove
  has_many :sectors,
           through: :product_sectors,
           after_add: :association_add,
           before_remove: :association_remove

  has_many :product_building_blocks,
           dependent: :delete_all,
           after_add: :association_add,
           before_remove: :association_remove
  has_many :building_blocks,
           through: :product_building_blocks,
           dependent: :delete_all,
           after_add: :association_add,
           before_remove: :association_remove

  has_many :product_sustainable_development_goals,
           dependent: :delete_all,
           after_add: :association_add,
           before_remove: :association_remove
  has_many :sustainable_development_goals,
           through: :product_sustainable_development_goals,
           dependent: :delete_all,
           after_add: :association_add,
           before_remove: :association_remove

  has_many :include_relationships, -> { where(relationship_type: 'composed') },
           foreign_key: :from_product_id,
           class_name: 'ProductProductRelationship',
           after_add: :association_add,
           before_remove: :association_remove
  has_many :includes,
           through: :include_relationships,
           source: :to_product,
           after_add: :association_add,
           before_remove: :association_remove

  has_many :interop_relationships, -> { where(relationship_type: 'interoperates') },
           foreign_key: :from_product_id,
           class_name: 'ProductProductRelationship',
           after_add: :association_add,
           before_remove: :association_remove
  has_many :interoperates_with,
           through: :interop_relationships,
           source: :to_product,
           dependent: :delete_all,
           after_add: :association_add,
           before_remove: :association_remove

  has_many :references,
           foreign_key: :to_product_id,
           class_name: 'ProductProductRelationship',
           dependent: :delete_all,
           after_add: :association_add,
           before_remove: :association_remove

  has_and_belongs_to_many :use_case_steps,
                          join_table: :use_case_steps_products,
                          dependent: :delete_all,
                          after_add: :association_add,
                          before_remove: :association_remove

  has_and_belongs_to_many :plays,
                          join_table: :plays_products,
                          dependent: :delete_all

  has_and_belongs_to_many :origins,
                          join_table: :products_origins,
                          dependent: :delete_all,
                          after_add: :association_add,
                          before_remove: :association_remove

  has_and_belongs_to_many :projects,
                          join_table: :projects_products,
                          dependent: :delete_all,
                          after_add: :association_add,
                          before_remove: :association_remove

  has_and_belongs_to_many :endorsers,
                          join_table: :products_endorsers,
                          dependent: :delete_all

  has_and_belongs_to_many :countries,
                          join_table: :products_countries,
                          after_add: :association_add,
                          before_remove: :association_remove

  has_and_belongs_to_many :resources,
                          join_table: :products_resources,
                          dependent: :delete_all,
                          after_add: :association_add,
                          before_remove: :association_remove

  has_and_belongs_to_many :software_categories,
                          join_table: :product_categories,
                          dependent: :delete_all,
                          after_add: :association_add,
                          before_remove: :association_remove

  has_and_belongs_to_many :software_features,
                          join_table: :product_features,
                          dependent: :delete_all,
                          after_add: :association_add,
                          before_remove: :association_remove

  validates :name, presence: true, length: { maximum: 300 }

  STAGES = %w[pilot scaling mature].freeze
  validates :product_stage, inclusion: { in: STAGES }, allow_nil: true

  scope :name_contains, ->(name) { where('LOWER(products.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(products.slug) like LOWER(?)', "#{slug}%\\_") }
  scope :name_and_slug_search, ->(name, slug) { where('products.name = ? OR products.slug = ?', name, slug) }
  scope :featured, -> { where(featured: true) }

  def set_extra_attribute(name:, value:, type: nil)
    self.extra_attributes ||= []

    attribute = extra_attributes.find { |attr| attr['name'] == name }

    if attribute
      attribute['value'] = value
      attribute['type'] = type if type
    else
      self.extra_attributes << { 'name' => name, 'value' => value, 'type' => type }
    end

    save
  end

  def get_extra_attribute(name)
    attribute = extra_attributes.find { |attr| attr['name'] == name }
    attribute ? attribute['value'] : nil
  end

  def method_missing(method_name, *arguments)
    if method_name.to_s.end_with?('=')
      attribute_name = method_name.to_s.chomp('=')
      set_extra_attribute(name: attribute_name, value: arguments.first)
    else
      get_extra_attribute(method_name.to_s)
    end
  end

  def respond_to_missing?(_method_name, _include_private = false)
    true
  end

  amoeba do
    enable

    exclude_association :endorsers
    exclude_association :include_relationships
    exclude_association :interop_relationships
    exclude_association :organization_products
    exclude_association :product_building_blocks
    exclude_association :product_classifications
    exclude_association :projects
    exclude_association :references
    exclude_association :resources
    exclude_association :use_case_steps
  end

  def sync_associations(source_product)
    destination_organizations = []
    source_product.organizations.each do |source_organization|
      organization = Organization.find_by(slug: source_organization.slug)
      destination_organizations << organization unless organization.nil?
    end
    self.organizations = destination_organizations
  end

  def sync_record(copy_of_product)
    ActiveRecord::Base.transaction do
      self.product_descriptions = copy_of_product.product_descriptions
      self.countries = copy_of_product.countries
      self.product_indicators = copy_of_product.product_indicators
      self.product_repositories = copy_of_product.product_repositories
      self.sectors = copy_of_product.sectors
      self.sustainable_development_goals = copy_of_product.sustainable_development_goals
      save!

      update!(copy_of_product.attributes.except('id', 'created_at', 'updated_at'))
    end
  end

  def self.first_duplicate(name, slug)
    find_by('name = ? OR slug = ? OR ? = ANY(aliases)', name, slug, name)
  end

  def image_file
    if File.exist?(File.join('public', 'assets', 'products', "#{slug}.png"))
      "/assets/products/#{slug}.png"
    else
      '/assets/products/product-placeholder.svg'
    end
  end

  def sectors_localized
    sectors.where('locale = ?', I18n.locale)
  end

  def product_description_localized
    description = product_descriptions
                  .find_by(locale: I18n.locale)
    if description.nil?
      description = product_descriptions
                    .find_by(locale: 'en')
    end
    description
  end

  def owner
    owner_id = nil
    owners = User.where('? = ANY(user_products)', id)
    owner_id = owners.first.id unless owners.empty?
    owner_id
  end

  def main_repository
    main_repository = product_repositories.find_by(main_repository: true, deleted: false)
    if main_repository.nil?
      main_repository = product_repositories.where(deleted: false).first
    end
    main_repository
  end

  def current_projects(num_projects)
    projects.limit(num_projects[:first])
  end

  def overall_maturity_score
    return nil if maturity_score.nil?

    maturity_score['overallScore'].is_a?(Numeric) ? maturity_score['overallScore'].to_f : nil
  end

  def maturity_score_details
    return [] if maturity_score.nil?

    maturity_score['rubricCategories']
  end

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end

  def self.to_csv
    attributes = %w[id name slug website repository organizations origins]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |p|
        organizations = p.organizations
                         .map(&:name)
                         .join('; ')
        origins = p.origins
                   .map(&:name)
                   .join('; ')

        csv << [p.id, p.name, p.slug, p.website, p.main_repository, organizations, origins]
      end
    end
  end

  def self_url(options = {})
    if options[:api_path].present?
      return "#{options[:api_path]}/govstack_products/#{slug}" if options[:govstack_path].present?
      return "#{options[:api_path]}/products/#{slug}" unless options[:govstack_path].present?
    end
    return options[:item_path] if options[:item_path].present?
    "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/products" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    if options[:item_path].present?
      return options[:item_path].sub("/govstack_products/#{slug}", '') if options[:govstack_path].present?
      return options[:item_path].sub("/products/#{slug}", '') unless options[:govstack_path].present?
    end

    if options[:collection_path].present?
      return options[:collection_path].sub('/govstack_products', '') if options[:govstack_path].present?
      options[:collection_path].sub('/products', '') unless options[:govstack_path].present?
    end
  end

  def govstack_path(options = {})
    options[:govstack_path]
  end

  def as_json(options = {})
    json = super(options)
    if options[:include_relationships].present?
      child_options = { api_path: api_path(options) }
      json['organizations'] = organizations.as_json(child_options.merge({ only: %i[name slug website] }))
      json['origins'] = origins.as_json(child_options.merge({ only: %i[name slug], api_source: 'products' }))
      json['building_blocks'] = building_blocks.as_json(child_options.merge({ only: %i[name slug] }))
      json['repositories'] = product_repositories.as_json(child_options.merge({ only: %i[name slug absolute_url] }))
      json['sectors'] = sectors.as_json(child_options.merge({ only: %i[name slug locale] }))

      sdgs = sustainable_development_goals
      json['sustainable_development_goals'] = sdgs.as_json(child_options.merge({ only: %i[name slug number] }))
    end
    json['self_url'] = self_url(options) if options[:collection_path].present? || options[:api_path].present?
    json['collection_url'] = collection_url(options) if options[:item_path].present?
    json
  end

  def self.serialization_options
    { except: %i[id statistics license_analysis default_url status created_at updated_at start_assessment] }
  end

  def sustainable_development_goals_mapping_status
    return nil if sustainable_development_goals.nil? || sustainable_development_goals.empty?

    product_sustainable_development_goals.each do |sustainable_development_goal|
      mapping_status = sustainable_development_goal.mapping_status
      return mapping_status unless mapping_status.nil?
    end
    nil
  end

  def building_blocks_mapping_status
    return nil if building_blocks.nil? || building_blocks.empty?

    product_building_blocks.each do |building_block|
      mapping_status = building_block.mapping_status
      return mapping_status unless mapping_status.nil?
    end
    nil
  end

  def product_indicators
    product_indicators = ProductIndicator.where(product_id: id)

    product_indicators_list = []
    product_indicators.each do |indicator|
      category = CategoryIndicator.find_by(id: indicator.category_indicator_id)
      unless category.rubric_category_id.nil?
        product_indicators_list << indicator
      end
    end
    product_indicators_list
  end

  def not_assigned_category_indicators
    product_indicators = ProductIndicator.where(product_id: id)

    used_categories_ids = []
    product_indicators.each do |indicator|
      current_category = CategoryIndicator.find_by(id: indicator.category_indicator_id)
      unless current_category.rubric_category_id.nil?
        used_categories_ids << current_category.id
      end
    end

    not_used_categories = []
    CategoryIndicator.all.each do |category|
      if !category.id.in?(used_categories_ids) && !category.rubric_category_id.nil?
        not_used_categories << category
      end
    end

    not_used_categories
  end

  def playbooks
    plays = Play.joins(:products).where(products: { id: })
    Playbook.joins(:plays).where(plays: { id: plays.ids }, draft: false).uniq
  end

  # rubocop:disable Naming/PredicateName
  def is_linked_with_dpi
    building_blocks.each do |building_block|
      return true if building_block.category == BuildingBlock.category_types[:DPI]
    end
    false
  end
end
