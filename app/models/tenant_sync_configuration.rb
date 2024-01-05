# frozen_string_literal: true

class TenantSyncConfiguration < ApplicationRecord
  include Auditable

  scope :name_contains, ->(name) { where('LOWER(task_trackers.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(task_trackers.slug) like LOWER(?)', "#{slug}\\_%") }

  def to_param
    slug
  end
end
