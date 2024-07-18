# frozen_string_literal: true

class OrganizationDataset < ApplicationRecord
  include AssociationSource

  belongs_to :organization
  belongs_to :dataset

  attribute :org_type, :string
  enum org_type: { owner: 'owner', maintainer: 'maintainer', funder: 'funder', implementer: 'implementer' }

  after_initialize :set_default_type, if: :new_record?
  after_initialize :default_association_source, if: :auditable_association_object

  def default_association_source
    self.association_source = OrganizationDataset.LEFT
  end

  # overridden
  def generate_slug
    self.slug = "#{organization.slug}-#{dataset.slug}" if !organization.nil? && !dataset.nil?
  end

  def set_default_type
    self.organization_type ||= :owner
  end

  def audit_id_value
    if association_source == OrganizationDataset.LEFT
      dataset&.slug
    else
      organization&.slug
    end
  end

  def audit_field_name
    if association_source == OrganizationDataset.LEFT
      Dataset.name.pluralize.downcase
    else
      Organization.name.pluralize.downcase
    end
  end
end
