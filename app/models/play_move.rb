# frozen_string_literal: true

class PlayMove < ApplicationRecord
  include Auditable

  belongs_to :play

  has_many :play_move_descriptions, dependent: :destroy
  has_and_belongs_to_many :resources, join_table: :play_moves_resources

  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  def play_move_description_localized
    description = play_move_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                        .find_by(locale: I18n.locale)
    if description.nil?
      description = play_move_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                          .find_by(locale: 'en')
    end
    description
  end

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end

  def play_name
    play = Play.find(play_id)
    play.name
  end

  def play_slug
    play = Play.find(play_id)
    play.slug
  end
end
