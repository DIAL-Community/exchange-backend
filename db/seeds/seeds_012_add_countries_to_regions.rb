# frozen_string_literal: true

require 'modules/slugger'

african_countries = [
  'Algeria',
  'Angola',
  'Benin',
  'Botswana',
  'Burkina Faso',
  'Burundi',
  'Cameroon',
  'Cape Verde',
  'Central African Republic',
  'Chad',
  'Comoros',
  'Congo (Republic of the)',
  'Côte d\'Ivoire',
  'Democratic Republic of the Congo',
  'Djibouti',
  'Egypt',
  'Equatorial Guinea',
  'Eritrea',
  'Eswatini',
  'Ethiopia',
  'Gabon',
  'Gambia',
  'Ghana',
  'Guinea',
  'Guinea-Bissau',
  'Kenya',
  'Lesotho',
  'Liberia',
  'Libya',
  'Madagascar',
  'Malawi',
  'Mali',
  'Mauritania',
  'Mauritius',
  'Morocco',
  'Mozambique',
  'Namibia',
  'Niger',
  'Nigeria',
  'Rwanda',
  'Sao Tome and Principe',
  'Senegal',
  'Seychelles',
  'Sierra Leone',
  'Somalia',
  'South Africa',
  'South Sudan',
  'Sudan',
  'Tanzania',
  'Togo',
  'Tunisia',
  'Uganda',
  'Western Sahara',
  'Zambia',
  'Zimbabwe'
]

asian_countries = [
  'Afghanistan',
  'Armenia',
  'Azerbaijan',
  'Bahrain',
  'Bangladesh',
  'Bhutan',
  'Brunei',
  'Cambodia',
  'China',
  'Cyprus',
  'East Timor',
  'Georgia',
  'India',
  'Indonesia',
  'Iran',
  'Iraq',
  'Israel',
  'Japan',
  'Jordan',
  'Kazakhstan',
  'Kuwait',
  'Kyrgyzstan',
  'Laos',
  'Lebanon',
  'Malaysia',
  'Maldives',
  'Mongolia',
  'Myanmar',
  'Nepal',
  'North Korea',
  'Oman',
  'Pakistan',
  'Palestine',
  'Philippines',
  'Qatar',
  'Russia',
  'Saudi Arabia',
  'Singapore',
  'South Korea',
  'Sri Lanka',
  'Syria',
  'Taiwan',
  'Tajikistan',
  'Thailand',
  'Turkey',
  'Turkmenistan',
  'United Arab Emirates',
  'Uzbekistan',
  'Vietnam',
  'Yemen'
]

north_american_countries = [
  'Canada',
  'United States',
  'Mexico',
  'Belize', 'Costa Rica', 'El Salvador', 'Guatemala', 'Honduras', 'Nicaragua', 'Panama',
  'Anguilla',
  'Antigua and Barbuda',
  'Aruba',
  'Bahamas',
  'Barbados',
  'Bermuda',
  'British Virgin Islands',
  'Cayman Islands',
  'Costa Rica',
  'Cuba',
  'Curacao',
  'Dominica',
  'Dominican Republic',
  'Grenada',
  'Greenland',
  'Guadeloupe',
  'Haiti',
  'Jamaica',
  'Martinique',
  'Montserrat',
  'Puerto Rico',
  'Saint Kitts and Nevis',
  'Saint Lucia',
  'Trinidad and Tobago',
  'Turks and Caicos Islands',
  'United States Virgin Islands'
]

central_american_countries = [
  'Belize', 'Costa Rica', 'El Salvador', 'Guatemala', 'Honduras', 'Nicaragua', 'Panama'
]

south_american_countries = [
  'Argentina',
  'Bolivia',
  'Brazil',
  'Chile',
  'Colombia',
  'Ecuador',
  'Falkland Islands',
  'French Guiana',
  'Guyana',
  'Paraguay',
  'Peru',
  'Suriname',
  'Uruguay',
  'Venezuela'
]

european_countries = [
  'Albania',
  'Andorra',
  'Austria',
  'Belarus',
  'Belgium',
  'Bosnia and Herzegovina',
  'Bulgaria',
  'Croatia',
  'Cyprus',
  'Czech Republic',
  'Denmark',
  'Estonia',
  'Finland',
  'France',
  'Georgia',
  'Germany',
  'Greece',
  'Hungary',
  'Iceland',
  'Ireland',
  'Italy',
  'Kosovo',
  'Latvia',
  'Liechtenstein',
  'Lithuania',
  'Luxembourg',
  'Malta',
  'Moldova',
  'Monaco',
  'Montenegro',
  'Netherlands',
  'Norway',
  'Poland',
  'Portugal',
  'Romania',
  'Russia',
  'San Marino',
  'Serbia',
  'Slovakia',
  'Slovenia',
  'Spain',
  'Sweden',
  'Switzerland',
  'Ukraine',
  'United Kingdom',
  'Vatican City'
]

# Create Africa region

africa_region = Region.find_by(name: 'Africa') || Region.new(name: 'Africa')
africa_region.slug = reslug_em(africa_region.name)
africa_region.description = 'All Countries in Africa'
africa_region.save

african_countries.each do |country|
  curr_country = Country.find_by(name: country)
  next if curr_country.nil?

  country_region = RegionsCountry.find_by(country_id: curr_country.id, region_id: africa_region.id) ||
    RegionsCountry.new(country_id: curr_country.id, region_id: africa_region.id)
  country_region.save
end

asia_region = Region.find_by(name: 'Asia') || Region.new(name: 'Asia')
asia_region.slug = reslug_em(asia_region.name)
asia_region.description = 'All Countries in Asia'
asia_region.save

asian_countries.each do |country|
  curr_country = Country.find_by(name: country)
  next if curr_country.nil?

  country_region = RegionsCountry.find_by(country_id: curr_country.id, region_id: asia_region.id) ||
    RegionsCountry.new(country_id: curr_country.id, region_id: asia_region.id)
  country_region.save
end

europe_region = Region.find_by(name: 'Europe') || Region.new(name: 'Europe')
europe_region.slug = reslug_em(europe_region.name)
europe_region.description = 'All Countries in Europe'
europe_region.save

european_countries.each do |country|
  curr_country = Country.find_by(name: country)
  next if curr_country.nil?

  country_region = RegionsCountry.find_by(country_id: curr_country.id, region_id: europe_region.id) ||
    RegionsCountry.new(country_id: curr_country.id, region_id: europe_region.id)
  country_region.save
end

north_america_region = Region.find_by(name: 'North America') || Region.new(name: 'North America')
north_america_region.slug = reslug_em(north_america_region.name)
north_america_region.description = 'All Countries in North America'
north_america_region.save

north_american_countries.each do |country|
  curr_country = Country.find_by(name: country)
  next if curr_country.nil?

  country_region = RegionsCountry.find_by(country_id: curr_country.id, region_id: north_america_region.id) ||
    RegionsCountry.new(country_id: curr_country.id, region_id: north_america_region.id)
  country_region.save
end

south_america_region = Region.find_by(name: 'South America') || Region.new(name: 'South America')
south_america_region.slug = reslug_em(south_america_region.name)
south_america_region.description = 'All Countries in South America'
south_america_region.save

south_american_countries.each do |country|
  curr_country = Country.find_by(name: country)
  next if curr_country.nil?

  country_region = RegionsCountry.find_by(country_id: curr_country.id, region_id: south_america_region.id) ||
    RegionsCountry.new(country_id: curr_country.id, region_id: south_america_region.id)
  country_region.save
end

central_america_region = Region.find_by(name: 'Central America') || Region.new(name: 'Central America')
central_america_region.slug = reslug_em(central_america_region.name)
central_america_region.description = 'All Countries in Central America'
central_america_region.save

central_american_countries.each do |country|
  curr_country = Country.find_by(name: country)
  next if curr_country.nil?

  country_region = RegionsCountry.find_by(country_id: curr_country.id, region_id: central_america_region.id) ||
    RegionsCountry.new(country_id: curr_country.id, region_id: central_america_region.id)
  country_region.save
end
