# frozen_string_literal: true

class Play < ApplicationRecord
  include Auditable

  has_many :play_descriptions, dependent: :destroy
  has_many :play_moves, -> { order('play_moves.move_order ASC') }, dependent: :destroy
  has_and_belongs_to_many :playbooks, join_table: :playbook_plays
  has_and_belongs_to_many :products, join_table: :plays_products
  has_and_belongs_to_many :building_blocks, join_table: :plays_building_blocks

  scope :name_contains, ->(name) { where('LOWER(plays.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(plays.slug) like LOWER(?)', "#{slug}\\_%") }

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end

  def play_description_localized
    description = play_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                   .find_by(locale: I18n.locale)
    if description.nil?
      description = play_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                     .find_by(locale: 'en')
    end
    description
  end

  def image_file
    if File.exist?(File.join('public', 'assets', 'playbooks', "#{slug}.png"))
      "/assets/playbooks/#{slug}.png"
    else
      '/assets/playbooks/playbook-placeholder.png'
    end
  end
end
