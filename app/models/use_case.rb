# frozen_string_literal: true

require('csv')

class UseCase < ApplicationRecord
  include EntityStatusType
  include Auditable

  belongs_to :sector
  has_many :sdg_targets,
           after_add: :association_add, before_remove: :association_remove

  has_many :use_case_steps, -> { order(step_number: :asc) }, dependent: :destroy
  has_many :use_case_headers, dependent: :destroy
  has_many :use_case_descriptions, dependent: :destroy

  has_and_belongs_to_many :opportunities, join_table: :opportunities_use_cases
  has_and_belongs_to_many :sdg_targets, join_table: :use_cases_sdg_targets,
                                        after_add: :association_add, before_remove: :association_remove

  scope :name_contains, ->(name) { where('LOWER(use_cases.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(use_cases.slug) like LOWER(?)', "#{slug}\\_%") }

  attr_accessor :uc_desc, :ucs_header, :building_blocks, :workflows

  def image_file
    if File.exist?(File.join('public', 'assets', 'use_cases', "#{slug}.png"))
      "/assets/use_cases/#{slug}.png"
    else
      '/assets/use_cases/use_case_placeholder.png'
    end
  end

  def use_case_description_localized
    description = use_case_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                       .find_by(locale: I18n.locale)
    if description.nil?
      description = use_case_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                         .find_by(locale: 'en')
    end
    description
  end

  # overridden
  def to_param
    slug
  end

  def self_url(options = {})
    return "#{options[:api_path]}/use_cases/#{slug}" if options[:api_path].present?
    return options[:item_path] if options[:item_path].present?
    return "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/use_cases" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    return options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    return options[:item_path].sub("/use_cases/#{slug}", '') if options[:item_path].present?
    return options[:collection_path].sub('/use_cases', '') if options[:collection_path].present?
  end

  def as_json(options = {})
    json = super(options)
    json['sector'] = sector.as_json({ only: %i[name slug], api_path: api_path(options) })
    if options[:include_relationships].present?
      json['use_case_steps'] = use_case_steps.as_json({ only: %i[name slug website], api_path: api_path(options) })
    end
    json['self_url'] = self_url(options) if options[:collection_path].present? || options[:api_path].present?
    json['collection_url'] = collection_url(options) if options[:item_path].present?
    json
  end

  def self.to_csv
    attributes = %w[id name slug description sdg_targets use_case_steps]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |p|
        sdg_targets = p.sdg_targets
                       .map(&:name)
                       .join('; ')
        use_case_steps = p.use_case_steps
                          .map(&:name)
                          .join('; ')
        csv << [p.id, p.name, p.slug, p.description, sdg_targets, use_case_steps]
      end
    end
  end

  def self.serialization_options
    {
      except: %i[id sector_id created_at updated_at description],
      include: {
        use_case_descriptions: { only: [:description] },
        sdg_targets: { only: %i[name target_number] },
        use_case_steps: { only: %i[name description],
                          include: {
                            use_case_step_descriptions: { only: [:description] }
                          } }
      }
    }
  end
end
