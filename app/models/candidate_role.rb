# frozen_string_literal: true

class CandidateRole < ApplicationRecord
  scope :email_contains, ->(email) { where('LOWER(email) like LOWER(?)', "%#{email}%") }

  def candidate_role_product
    Product.find(product_id) unless product_id.nil?
  end

  def candidate_role_organization
    Organization.find(organization_id) unless organization_id.nil?
  end

  def candidate_role_dataset
    Dataset.find(dataset_id) unless dataset_id.nil?
  end

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
