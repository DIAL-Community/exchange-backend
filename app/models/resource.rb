# frozen_string_literal: true

class Resource < ApplicationRecord
  include Auditable

  has_and_belongs_to_many(
    :organizations,
    after_add: :association_add,
    before_remove: :association_remove,
    dependent: :delete_all
  )

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }

  def image_file
    if File.exist?(File.join('public', 'assets', 'resources', "#{slug}.png"))
      "/assets/resources/#{slug}.png"
    else
      '/assets/resources/resource_placeholder.png'
    end
  end
end
