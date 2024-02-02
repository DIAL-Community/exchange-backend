# frozen_string_literal: true

class Resource < ApplicationRecord
  include Auditable

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
    if File.exist?(File.join('public', 'assets', 'resources', "#{slug}.png"))
      "/assets/resources/#{slug}.png"
    else
      '/assets/resources/resource-placeholder.png'
    end
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
