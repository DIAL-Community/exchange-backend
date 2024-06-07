# frozen_string_literal: true

class Playbook < ApplicationRecord
  include Auditable

  attr_accessor :playbook_overview, :playbook_audience, :playbook_outcomes, :playbook_cover

  has_many :playbook_descriptions, dependent: :destroy
  has_many :playbook_plays,
            -> { order('playbook_plays.play_order ASC') }

  has_and_belongs_to_many :sectors, join_table: :playbooks_sectors
  has_and_belongs_to_many :plays,
                          -> { order('playbook_plays.play_order') },
                          dependent: :destroy,
                          join_table: :playbook_plays

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end

  # Not needed, but adding it to make it balance with playbook plays
  def all_plays
    plays
  end

  def published_plays
    plays.where(draft: false)
  end

  def all_playbook_plays
    returned_list = []
    playbook_plays.each do |playbook_play|
      playbook_play_hash = playbook_play.attributes
      playbook_play_hash['playbook_slug'] = slug
      playbook_play_hash['play_slug'] = playbook_play.play.slug
      playbook_play_hash['play_name'] = playbook_play.play.name
      returned_list << playbook_play_hash
    end
    returned_list
  end

  def published_playbook_plays
    returned_list = []
    playbook_plays.each do |playbook_play|
      current_play = playbook_play.play
      next if current_play.draft

      playbook_play_hash = playbook_play.attributes
      playbook_play_hash['play_slug'] = current_play.slug
      playbook_play_hash['play_name'] = current_play.name
      playbook_play_hash['playbook_slug'] = slug
      playbook_play_hash['playbook_name'] = name
      returned_list << playbook_play_hash
    end
    returned_list
  end

  def playbook_description_localized
    description = playbook_descriptions.order(Arel.sql('LENGTH(overview) DESC'))
                                       .find_by(locale: I18n.locale)
    if description.nil?
      description = playbook_descriptions.order(Arel.sql('LENGTH(overview) DESC'))
                                         .find_by(locale: 'en')
    end
    description
  end

  def image_file
    if File.exist?(File.join('public', 'assets', 'playbooks', "#{slug}.png"))
      "/assets/playbooks/#{slug}.png"
    else
      '/assets/playbooks/playbook-placeholder.svg'
    end
  end
end
