# frozen_string_literal: true

# Default installation user account.
default_user = User.find_by(email: Rails.configuration.settings['admin_email'])
if default_user.nil?
  default_user = User.new(
    email: Rails.configuration.settings['admin_email'],
    username: 'admin',
    password: 'admin-password',
    password_confirmation: 'admin-password',
    created_at: Time.now.utc,
    updated_at: Time.now.utc,
    confirmed_at: Time.now.utc
  )
end
if default_user.save!
  puts 'Default installation user account updated.'
  default_user.roles << 'admin' unless default_user.roles.include?('admin')
  default_user.save!
end

# Default installation organization.
setting = Setting.find_by(slug: 'default-organization')
if setting.nil?
  setting = Setting.new(
    name: 'Default Organization',
    slug: Rails.configuration.settings['installation_organization_key']
  )
end
setting.description = <<-SETTING_DESCRIPTION
  <p>
    The default organization who will own the products (must use the slug value).
  </p>
SETTING_DESCRIPTION
setting.value = 'digital-impact-alliance-dial'
if setting.save!
  puts 'Default installation organization updated.'
end

# Default tag name to be used to mark COVID-19 related entities.
setting = Setting.find_by(slug: 'default-covid19-tag')
if setting.nil?
  setting = Setting.new(
    slug: 'default-covid19-tag',
    name: 'Default COVID-19 Tag'
  )
end
setting.description = <<-SETTING_DESCRIPTION
  <p>
    The default tag name for COVID-19 related objects.
  </p>
SETTING_DESCRIPTION
setting.value = 'COVID-19'
if setting.save!
  puts 'Default tag name to be used to mark COVID-19 related entities updated.'
end

# Default maturity rubric slug to be used to evaluate products.
setting = Setting.find_by(slug: Rails.configuration.settings['default_maturity_rubric_slug'])
if setting.nil?
  setting = Setting.new(
    name: 'Default Maturity Rubric Slug',
    slug: Rails.configuration.settings['default_maturity_rubric_slug']
  )
end
setting.description = <<-SETTING_DESCRIPTION
  <p>
    The key to the default definition of the maturity rubric.
  </p>
SETTING_DESCRIPTION
setting.value = 'default-maturity-rubric'
if setting.save!
  puts 'Default maturity rubric setting updated.'
end

setting = Setting.find_by(slug: 'default-map-center-position')
if setting.nil?
  setting = Setting.new(
    name: 'Default Map Center Position',
    slug: 'default-map-center-position'
  )
end
setting.description = <<-SETTING_DESCRIPTION
  <p>
    The center position when opening any map pages. It will ask for permission
    if you pick 'country'. When empty or filled with non 'country', the pages will
    default to world as the center point.
  </p>
SETTING_DESCRIPTION
setting.value = 'country'
if setting.save!
  puts 'Default center setting when opening map pages updated.'
end

setting = Setting.find_by(slug: 'default-sector-list')
if setting.nil?
  setting = Setting.new(
    name: 'Default Sector List',
    slug: 'default-sector-list',
  )
end
setting.description = <<-SETTING_DESCRIPTION
  <p>
    The list of sectors that will be used for product and project assignments.
    DIAL's sector list is the default.
  </p>
SETTING_DESCRIPTION
setting.value = 'DIAL OSC'
if setting.save!
  puts 'Default sector list to be used for product and project assignments updated.'
end

# Remove unused settings. They're mainly settings with older style of slug definition.
Setting
  .where(slug: [
    'default_organization',
    'default_covid19_tag',
    'default_maturity_rubric_slug',
    'default_map_center_position',
    'default_sector_list'
  ])
  .destroy_all

tag = Tag.find_by(slug: 'covid19')
if tag.nil?
  tag = Tag.new(
    name: 'COVID-19',
    slug: 'covid19'
  )
end

if tag.save!
  puts 'Default COVID-19 tag updated.'
  tag_description = TagDescription.new(
    tag_id: tag.id,
    locale: 'en',
    description: <<-TAG_DESCRIPTION
      Coronavirus disease 2019 (COVID-19) is an infectious disease caused by severe
      acute respiratory syndrome coronavirus 2 (SARS-CoV-2). The World Health
      Organization (WHO) declared the 2019–20 coronavirus outbreak a Public Health
      Emergency of International Concern (PHEIC) on 30 January 2020 and a pandemic
      on 11 March 2020.'
    TAG_DESCRIPTION
  )
  tag_description.save!
end

if Origin.where(slug: 'manually-entered').count.zero?
  Origin.create!(
    name: 'Manually Entered',
    description: 'Project information are manually entered by user.',
    slug: 'manually-entered'
  )
end

if Origin.where(slug: 'dial').count.zero?
  Origin.create!(
    name: 'Digital Impact Alliance',
    description: 'Information curated by DIAL.',
    slug: 'dial'
  )
end

if Endorser.where(slug: 'dpga').count.zero?
  Endorser.create(
    name: 'Digital Public Goods Alliance',
    description: 'This product has been screened as a Digital Public Good by the Digital Public Goods Alliance.',
    slug: 'dpga'
  )
end

if Endorser.where(slug: 'dsq').count.zero?
  Endorser.create(
    name: 'Digital Square',
    description: 'This product has been screened as a Global Good by Digital Square.',
    slug: 'dsq'
  )
end

Dir[Rails.root.join('db/seeds/*.rb')].sort.each do |file|
  puts "Processing #{file.split('/').last}."
  require file
end
