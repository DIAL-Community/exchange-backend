class UseCase < ApplicationRecord
  belongs_to :sector
  has_many :sdg_targets

  has_and_belongs_to_many :sdg_targets, join_table: :use_cases_sdg_targets
  has_and_belongs_to_many :workflows, join_table: :workflows_use_cases

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%")}
end