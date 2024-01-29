# frozen_string_literal: true

class TaskTracker < ApplicationRecord
  include Auditable

  has_many :task_tracker_descriptions, dependent: :destroy

  scope :name_contains, ->(name) { where('LOWER(task_trackers.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(task_trackers.slug) like LOWER(?)', "#{slug}\\_%") }

  def description_localized
    description = task_tracker_descriptions.find_by(locale: I18n.locale)
    if description.nil?
      description = task_tracker_descriptions.find_by(locale: 'en')
    end
    description
  end

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
