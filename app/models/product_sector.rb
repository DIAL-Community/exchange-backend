# frozen_string_literal: true

class ProductSector < ApplicationRecord
  include MappingStatusType
  include AssociationSource

  belongs_to :product
  belongs_to :sector

  after_initialize :default_association_source, if: :auditable_association_object

  def default_association_source
    self.association_source = ProductSector.LEFT
  end

  # overridden
  def generate_slug
    self.slug = "#{product.slug}-#{sector.slug}" if !product.nil? && !sector.nil?
  end

  def audit_id_value
    if association_source == ProductSector.LEFT
      sector&.slug
    else
      product&.slug
    end
  end

  def audit_field_name
    if association_source == ProductSector.LEFT
      Sector.name.pluralize.downcase
    else
      Product.name.pluralize.downcase
    end
  end
end
