# frozen_string_literal: true

class UseCaseStep < ApplicationRecord
  include Auditable

  belongs_to :use_case
  attr_accessor :ucs_desc

  has_many :use_case_step_descriptions, dependent: :destroy
  has_and_belongs_to_many :products,
                          join_table: :use_case_steps_products,
                          after_add: :association_add,
                          before_remove: :association_remove
  has_and_belongs_to_many :workflows,
                          join_table: :use_case_steps_workflows,
                          after_add: :association_add,
                          before_remove: :association_remove
  has_and_belongs_to_many :datasets,
                          join_table: :use_case_steps_datasets,
                          after_add: :association_add,
                          before_remove: :association_remove
  has_and_belongs_to_many :building_blocks,
                          join_table: :use_case_steps_building_blocks,
                          after_add: :association_add,
                          before_remove: :association_remove

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  amoeba do
    enable

    exclude_association :building_blocks
    exclude_association :datasets
    exclude_association :products
    exclude_association :workflows
  end

  def sync_associations(source_use_case_step)
    destination_building_blocks = []
    source_use_case_step.building_blocks.each do |source_building_block|
      building_block = BuildingBlock.find_by(slug: source_building_block.slug)
      destination_building_blocks << building_block unless building_block.nil?
    end
    self.building_blocks = destination_building_blocks

    destination_datasets = []
    source_use_case_step.datasets.each do |source_dataset|
      dataset = Dataset.find_by(slug: source_dataset.slug)
      destination_datasets << dataset unless dataset.nil?
    end
    self.datasets = destination_datasets

    destination_products = []
    source_use_case_step.products.each do |source_product|
      product = Product.find_by(slug: source_product.slug)
      destination_products << product unless product.nil?
    end
    self.products = destination_products

    destination_workflows = []
    source_use_case_step.workflows.each do |source_workflow|
      workflow = Workflow.find_by(slug: source_workflow.slug)
      destination_workflows << workflow unless workflow.nil?
    end
    self.workflows = destination_workflows
  end

  def sync_record(copy_of_use_case_step)
    ActiveRecord::Base.transaction do
      self.use_case_step_descriptions = copy_of_use_case_step.use_case_step_descriptions
      save!

      # Don't copy the source use_case_id as they might be different.
      update!(copy_of_use_case_step.attributes.except('id', 'created_at', 'updated_at', 'use_case_id'))
    end
  end

  def use_case_step_description_localized
    description = use_case_step_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                            .find_by(locale: I18n.locale)
    if description.nil?
      description = use_case_step_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                              .find_by(locale: 'en')
    end
    description
  end

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end

  def self_url(options = {})
    return "#{options[:api_path]}/use_cases/#{use_case.slug}/use_case_steps/#{slug}" if options[:api_path].present?
    return options[:item_path] if options[:item_path].present?
    "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/use_cases/#{use_case.slug}" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    return options[:item_path].sub("/use_cases/#{use_case.slug}/use_case_steps/#{slug}", '') \
      if options[:item_path].present?
    options[:collection_path].sub("/use_cases/#{use_case.slug}/use_case_steps", '') \
      if options[:collection_path].present?
  end

  def as_json(options = {})
    json = super(options)
    json['use_case'] = use_case.as_json({ only: %i[name slug], api_path: api_path(options) })
    json['self_url'] = self_url(options) if options[:collection_path].present? || options[:api_path].present?
    json['collection_url'] = collection_url(options) if options[:item_path].present?
    json
  end

  def self.serialization_options
    {
      except: %i[id use_case_id created_at updated_at],
      include: {
        use_case_step_descriptions: { only: [:description, :locale] }
      }
    }
  end
end
