# frozen_string_literal: true
require 'modules/slugger'

deleted_sector_names = ['Private Sector Engagement', 'Sustainable Development', 'Other']
deleted_sector_names.each do |sector_name|
  deleted_sectors = Sector.where(slug: slug_em(sector_name)).destroy_all
  puts "#{deleted_sectors.size} #{'sector'.pluralize(deleted_sectors.size)} with slug: #{slug_em(sector_name)}."
  unless deleted_sectors.size
    puts "#{'Sector'.pluralize(deleted_sectors.size)} deleted."
  end
end

translated_sector_names = {
  slug_em('Energy').to_s => {
    'en' => 'Energy',
    'de' => 'Energie',
    'es' => 'Energía',
    'fr' => 'Énergie',
    'pt' => 'Energia',
    'sw' => 'Nishati',
    'cs' => 'Energie'
  },
  slug_em('Media and Culture').to_s => {
    'en' => 'Media and Culture',
    'de' => 'Medien und Kultur',
    'es' => 'Medios y Cultura',
    'fr' => 'Médias et culture',
    'pt' => 'Mídia e Cultura',
    'sw' => 'Vyombo vya habari na Utamaduni',
    'cs' => 'Média a kultura'
  },
  slug_em('Tourism and Sports').to_s => {
    'en' => 'Tourism and Sports',
    'de' => 'Tourismus und Sport',
    'es' => 'Turismo y Deportes',
    'fr' => 'Tourisme et Sports',
    'pt' => 'Turismo e Esporte',
    'sw' => 'Utalii na Michezo',
    'cs' => 'Turistika a sport'
  }
}

sector_origin = Origin.find_by(slug: 'dial_osc')
translated_sector_names.each do |sector_slug, translated_names|
  translated_names.each do |locale, name|
    puts "Finding sector '#{name}' in '#{locale}' with slug: #{sector_slug}."
    sector = Sector.find_by(slug: sector_slug, locale: locale)
    next unless sector.nil?

    sector = Sector.new do |attribute|
      attribute.name = name
      attribute.slug = sector_slug
      attribute.locale = locale
      attribute.origin_id = sector_origin.id
    end

    if sector.save
      puts "Created sector '#{name}' in '#{locale}' with slug: #{sector_slug}."
    end
  end
end
