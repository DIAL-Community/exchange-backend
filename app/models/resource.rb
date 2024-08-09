# frozen_string_literal: true

class Resource < ApplicationRecord
  include Auditable

  belongs_to :organization, optional: true
  belongs_to :submitted_by, class_name: 'User', optional: true

  has_many :resource_building_blocks, dependent: :delete_all
  has_many :building_blocks, through: :resource_building_blocks, dependent: :delete_all

  has_and_belongs_to_many :use_cases,
                          join_table: :resources_use_cases,
                          dependent: :delete_all

  has_and_belongs_to_many :organizations,
                          after_add: :association_add,
                          before_remove: :association_remove,
                          dependent: :delete_all

  has_and_belongs_to_many :products,
                          join_table: :products_resources,
                          after_add: :association_add,
                          before_remove: :association_remove,
                          dependent: :delete_all

  has_and_belongs_to_many :countries,
                          join_table: :resources_countries,
                          after_add: :association_add,
                          before_remove: :association_remove,
                          dependent: :delete_all

  has_and_belongs_to_many :authors,
                          join_table: :resources_authors,
                          after_add: :association_add,
                          before_remove: :association_remove,
                          dependent: :delete_all

  scope :name_contains, ->(name) { where('LOWER(resources.name) like LOWER(?)', "%#{name}%") }
  scope :name_and_slug_search, -> (name, slug) { where('resources.name = ? OR resources.slug = ?', name, slug) }

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end

  def image_file
    return '/assets/resources/resource-placeholder.svg' if organization_id.nil?

    source_organization = Organization.find(organization_id)
    return '/assets/resources/resource-placeholder.svg' if source_organization.nil?

    if File.exist?(File.join('public', 'assets', 'organizations', "#{source_organization.slug}.png"))
      "/assets/organizations/#{source_organization.slug}.png"
    else
      '/assets/organizations/organization-placeholder.png'
    end
  end

  def building_blocks_mapping_status
    return nil if building_blocks.nil? || building_blocks.empty?

    product_building_blocks.each do |building_block|
      mapping_status = building_block.mapping_status
      return mapping_status unless mapping_status.nil?
    end
    nil
  end

  def resource_file
    if !resource_filename.nil? && File.exist?(File.join('public', 'assets', 'resources', resource_filename))
      "/assets/resources/#{resource_filename}"
    end
  end

  def products_ordered
    products&.order('products.name ASC')
  end

  def countries_ordered
    countries&.order('countries.name ASC')
  end

  def authors_ordered
    authors&.order('authors.name ASC')
  end
end
