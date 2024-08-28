# frozen_string_literal: true

class CandidateResource < ApplicationRecord
  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }

  has_and_belongs_to_many :countries,
                          join_table: :candidate_resources_countries,
                          dependent: :delete_all

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end

  def countries_ordered
    countries&.order('countries.name ASC')
  end
end
