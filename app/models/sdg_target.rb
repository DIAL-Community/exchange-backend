# frozen_string_literal: true

class SdgTarget < ApplicationRecord
  belongs_to :sustainable_development_goal, foreign_key: 'sdg_number', primary_key: 'number'

  has_and_belongs_to_many :use_cases, join_table: :use_cases_sdg_targets

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  def image_file
    png_filename = "goal-#{sdg_number}-target-#{target_number}.png"
    if File.exist?(File.join('public', 'assets', 'sdg-targets', png_filename))
      "/assets/sdg-targets/#{png_filename}"
    else
      '/assets/sdg-targets/sdg-target-placeholder.png'
    end
  end

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
