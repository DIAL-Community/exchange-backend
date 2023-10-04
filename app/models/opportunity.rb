# frozen_string_literal: true

class Opportunity < ApplicationRecord
  include Auditable

  enum opportunity_status_type: {
    CLOSED: 'CLOSED',
    OPEN: 'OPEN',
    UPCOMING: 'UPCOMING'
  }

  enum opportunity_type_type: {
    BID: 'BID',
    TENDER: 'TENDER',
    INNOVATION: 'INNOVATION',
    BUILDING_BLOCK: 'BUILDING BLOCK',
    OTHER: 'OTHER'
  }

  has_and_belongs_to_many(
    :sectors,
    dependent: :delete_all,
    join_table: :opportunities_sectors,
    after_add: :association_add,
    before_remove: :association_remove
  )

  has_and_belongs_to_many(
    :countries,
    dependent: :delete_all,
    join_table: :opportunities_countries,
    after_add: :association_add,
    before_remove: :association_remove
  )

  has_and_belongs_to_many(
    :organizations,
    dependent: :delete_all,
    join_table: :opportunities_organizations,
    after_add: :association_add,
    before_remove: :association_remove
  )

  has_and_belongs_to_many(
    :building_blocks,
    dependent: :delete_all,
    join_table: :opportunities_building_blocks,
    after_add: :association_add,
    before_remove: :association_remove
  )

  has_and_belongs_to_many(
    :use_cases,
    dependent: :delete_all,
    join_table: :opportunities_use_cases,
    after_add: :association_add,
    before_remove: :association_remove
  )

  belongs_to(:origin)

  validates :name, presence: true, length: { maximum: 300 }

  scope :name_contains, ->(name) { where('LOWER(opportunities.name) like LOWER(?)', "%#{name}%") }
  scope :name_and_slug_search, -> (name, slug) { where('opportunities.name = ? OR opportunities.slug = ?', name, slug) }

  def image_file
    if File.exist?(File.join('public', 'assets', 'opportunities', "#{slug}.png"))
      "/assets/opportunities/#{slug}.png"
    else
      '/assets/opportunities/opportunity_placeholder.png'
    end
  end

  def sectors_localized
    sectors&.where('locale = ?', I18n.locale)&.order('name ASC')
  end

  def countries_ordered
    countries&.order('name ASC')
  end

  def self.order_by_status
    order(
      Arel.sql(
        "CASE
          WHEN opportunity_status = 'CLOSED' THEN '3'
          WHEN opportunity_status = 'OPEN' THEN '1'
          WHEN opportunity_status = 'UPCOMING' THEN '2'
        END"
      )
    )
  end
end
