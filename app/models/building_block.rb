# frozen_string_literal: true

require('csv')

class BuildingBlock < ApplicationRecord
  include EntityStatusType
  include Auditable

  enum category_type: {
    DPI: 'DPI',
    FUNCTIONAL: 'FUNCTIONAL'
  }

  has_many :building_block_descriptions, dependent: :destroy

  has_many :product_building_blocks,
           dependent: :delete_all,
           after_add: :association_add,
           before_remove: :association_remove
  has_many :products,
           through: :product_building_blocks,
           after_add: :association_add,
           before_remove: :association_remove

  has_and_belongs_to_many :use_case_steps,
                          join_table: :use_case_steps_building_blocks,
                          after_add: :association_add,
                          before_remove: :association_remove

  has_and_belongs_to_many :workflows,
                          join_table: :workflows_building_blocks,
                          after_add: :association_add,
                          before_remove: :association_remove

  has_and_belongs_to_many :opportunities,
                          join_table: :opportunities_building_blocks

  scope :name_contains, ->(name) { where('LOWER(building_blocks.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(building_blocks.slug) like LOWER(?)', "#{slug}\\_%") }

  amoeba do
    enable

    exclude_association :opportunities
    exclude_association :product_building_blocks
    exclude_association :use_case_steps
    exclude_association :workflows
  end

  def sync_associations(source_building_block)
    destination_products = []
    source_building_block.products.each do |source_product|
      product = Product.find_by(slug: source_product.slug)
      destination_products << product unless product.nil?
    end
    self.products = destination_products

    destination_workflows = []
    source_building_block.workflows.each do |source_workflow|
      workflow = Workflow.find_by(slug: source_workflow.slug)
      destination_workflows << workflow unless workflow.nil?
    end
    self.workflows = destination_workflows
  end

  def sync_record(copy_of_building_block)
    ActiveRecord::Base.transaction do
      self.building_block_descriptions = copy_of_building_block.building_block_descriptions
      save!

      update!(copy_of_building_block.attributes.except('id', 'created_at', 'updated_at'))
    end
  end

  attr_accessor :bb_desc

  def building_block_description_localized
    description = building_block_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                             .find_by(locale: I18n.locale)
    if description.nil?
      description = building_block_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                               .find_by(locale: 'en')
    end
    description
  end

  def image_file
    if File.exist?(File.join('public', 'assets', 'building-blocks', "#{slug}.svg"))
      "/assets/building-blocks/#{slug}.svg"
    else
      '/assets/building-blocks/building-block-placeholder.svg'
    end
  end

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end

  def self_url(options = {})
    if options[:api_path].present?
      return "#{options[:api_path]}/govstack_building_blocks/#{slug}" if options[:govstack_path].present?
      return "#{options[:api_path]}/building_blocks/#{slug}" unless options[:govstack_path].present?
    end
    return options[:item_path] if options[:item_path].present?
    "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/building_blocks" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    if options[:item_path].present?
      return options[:item_path].sub("/govstack_building_blocks/#{slug}", '') if options[:govstack_path].present?
      return options[:item_path].sub("/building_blocks/#{slug}", '') unless options[:govstack_path].present?
    end

    if options[:collection_path].present?
      return options[:collection_path].sub('/govstack_building_blocks', '') if options[:govstack_path].present?
      options[:collection_path].sub('/building_blocks', '') unless options[:govstack_path].present?
    end
  end

  def govstack_path(options = {})
    options[:govstack_path]
  end

  def as_json(options = {})
    json = super(options)
    if options[:include_relationships].present?
      child_options = { api_path: api_path(options) }
      json['products'] = products.as_json(child_options.merge({ only: %i[name slug website] }))
      json['workflows'] = workflows.as_json(child_options.merge({ only: %i[name slug] }))
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
      except: %i[id created_at updated_at description entity_status_type],
      include: {
        building_block_descriptions: { only: [:description, :locale] }
      }
    }
  end
end
