# frozen_string_literal: true

class OrganizationContact < ApplicationRecord
  include AssociationSource

  belongs_to :contact
  belongs_to :organization

  after_initialize :default_association_source, if: :auditable_association_object

  def default_association_source
    self.association_source = OrganizationContact.LEFT
  end

  # overridden
  def generate_slug
    self.slug = "#{organization.slug}-#{contact.slug}" if !organization.nil? && !contact.nil?
  end

  def audit_id_value
    if association_source == OrganizationContact.LEFT
      contact&.slug
    else
      organization&.slug
    end
  end

  def audit_field_name
    if association_source == OrganizationContact.LEFT
      Contact.name.pluralize.downcase
    else
      Organization.name.pluralize.downcase
    end
  end
end
