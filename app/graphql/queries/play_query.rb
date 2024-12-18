# frozen_string_literal: true

module Queries
  class PlayQuery < Queries::BaseQuery
    argument :slug, String, required: true
    argument :owner, String, required: true
    type Types::PlayType, null: true

    def resolve(slug:, owner:)
      Play.find_by(slug:, owned_by: owner)
    end
  end

  class PlaysQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :playbook_slug, String, required: false, default_value: ''
    argument :owner, String, required: true
    type [Types::PlayType], null: false

    def resolve(search:, owner:, playbook_slug:)
      plays = Play.where(owned_by: owner)
      unless playbook_slug.blank?
        plays = plays.joins(:playbooks)
                     .where(playbooks: { slug: playbook_slug })
                     .order('playbook_plays.play_order')
      end
      plays = plays.name_contains(search) unless search.blank?
      plays = plays.order(:name)
      plays
    end
  end

  class SearchPlaybookPlaysQuery < Queries::BaseQuery
    argument :slug, String, required: true
    argument :owner, String, required: true

    type Types::PlayType.connection_type, null: false

    def resolve(slug:, owner:)
      Play.where(owned_by: owner)
          .joins(:playbooks)
          .where(playbooks: { slug: })
          .order('playbook_plays.play_order')
    end
  end

  class SearchPlaysQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :products, [String], required: false, default_value: []
    argument :owner, String, required: true

    type Types::PlayType.connection_type, null: false

    def resolve(search:, owner:, products:)
      plays = Play.where(owned_by: owner).order(:name)
      if !search.nil? && !search.to_s.strip.empty?
        name_plays = plays.name_contains(search)
        desc_plays = plays.joins(:play_descriptions)
                          .where('LOWER(description) like LOWER(?)', "%#{search}%")
        plays = plays.where(id: (name_plays + desc_plays).uniq)
      end

      filtered_products = products.reject { |x| x.nil? || x.empty? }
      unless filtered_products.empty?
        plays = plays.joins(:products)
                     .where(products: { id: filtered_products })
      end

      plays.distinct
    end
  end
end
