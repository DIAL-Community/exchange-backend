class Workflow < ApplicationRecord
    
  has_and_belongs_to_many :use_cases, join_table: :workflows_use_cases
  has_and_belongs_to_many :building_blocks, join_table: :workflows_building_blocks

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%")}
end