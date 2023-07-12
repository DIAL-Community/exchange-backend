# frozen_string_literal: true

class Resource < ApplicationRecord
  include Auditable

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }

  def image_file
    if File.exist?(File.join('public', 'assets', 'resources', "#{slug}.png"))
      "/assets/resources/#{slug}.png"
    else
      '/assets/resources/resource_placeholder.png'
    end
  end
end
