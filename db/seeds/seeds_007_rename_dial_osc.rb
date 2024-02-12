# frozen_string_literal: true

require 'modules/slugger'

origin = Origin.find_by(slug: 'dial_osc')
unless origin.nil?
  origin.name = 'DIAL'
  origin.slug = reslug_em('DIAL')
  origin.save!
end
