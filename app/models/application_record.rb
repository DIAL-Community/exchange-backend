# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to shards: {
    default: { writing: :primary, reading: :primary },
    govstack: { writing: :primary_govstack, reading: :primary_govstack },
    gdpir: { writing: :primary_gdpir, reading: :primary_gdpir }
  }

  attr_accessor :association_source

  before_save :generate_slug, if: :auditable_association_object

  scope :slug_simple_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}%") }

  def auditable_association_object
    belongs_to = self.class.reflect_on_all_associations(:belongs_to)
    has_many = self.class.reflect_on_all_associations(:has_many)

    has_many.empty? && belongs_to.size > 1 && self.class.include?(AssociationSource)
  end

  def generate_slug
    if has_attribute?(:slug)
      raise NotImplementedError, 'Auditable association object subclasses must define `generate_slug`.'
    end
  end

  def audit_id_value
    if auditable_association_object
      raise NotImplementedError, 'Auditable association object subclasses must define `audit_id_value`.'
    end
  end

  def audit_field_name
    if auditable_association_object
      raise NotImplementedError, 'Auditable association object subclasses must define `audit_field_name`.'
    end
  end
end
