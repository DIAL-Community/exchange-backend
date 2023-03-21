# frozen_string_literal: true

if User.count.zero? && User.where(email: Rails.configuration.settings['admin_email']).count.zero?
  user = User.new(email: Rails.configuration.settings['admin_email'],
                  password: 'admin-password',
                  password_confirmation: 'admin-password',
                  confirmed_at: Time.now.utc,
                  created_at: Time.now.utc,
                  updated_at: '1900-01-01',
                  role: 'admin')
  user.save(validate: false)
end

if Setting.where(slug: 'default_organization').count.zero?
  Setting.create!(name: 'Default Organization',
                  slug: Rails.configuration.settings['install_org_key'],
                  description: 'The default installation organization who own the product (must use the slug value).',
                  value: 'digital_impact_alliance_dial')
end

if Setting.where(slug: 'default_covid19_tag').count.zero?
  Setting.create!(name: 'Default COVID-19 Tag',
                  slug: 'default_covid19_tag',
                  description: 'The default tag name for COVID-19 related objects.',
                  value: 'COVID-19')
end

if Setting.where(slug: Rails.configuration.settings['default_maturity_rubric_slug']).count.zero?
  Setting.create!(name: 'Default Maturity Rubric Slug',
                  slug: Rails.configuration.settings['default_maturity_rubric_slug'],
                  description: 'The key to the default definition of the maturity rubric.',
                  value: 'default_maturity_rubric')
end

if Setting.where(slug: 'default_map_center_position').count.zero?
  Setting.create!(name: 'Default Map Center Position',
                  slug: 'default_map_center_position',
                  description: 'The center position for the map view. It will ask for permission ' \
                               "if you pick 'country'. When empty or filled with non 'country', " \
                               'will default to world.',
                  value: 'country')
end

if Setting.where(slug: 'default_sector_list').count.zero?
  Setting.create!(name: 'Default Sector List',
                  slug: 'default_sector_list',
                  description: 'The list of sectors that will be used for product and project ' \
                              "assignments. DIAL's sector list is the default.",
                  value: 'DIAL OSC')
end

if Tag.where(slug: 'covid19').count.zero?
  tag = Tag.create!(name: 'COVID-19',
                    slug: 'covid19')
  TagDescription
    .create!(tag_id: tag.id,
             locale: 'en',
             description: {
               "ops": [
                 {
                   'insert': 'Coronavirus disease 2019 (COVID-19) is an infectious disease caused by severe ' \
                             'acute respiratory syndrome coronavirus 2 (SARS-CoV-2). The World Health ' \
                             'Organization (WHO) declared the 2019–20 coronavirus outbreak a Public Health ' \
                             'Emergency of International Concern (PHEIC) on 30 January 2020 and a pandemic ' \
                             'on 11 March 2020.'
                 }
               ]
             })
end

if PortalView.where(slug: 'default').count.zero?
  PortalView.create!(name: 'Default',
                     slug: 'default',
                     description: 'Default portal view',
                     top_navs: %w[sdgs use_cases workflows building_blocks products organizations],
                     filter_navs: %w[sdgs use_cases workflows building_blocks products organizations locations
                                     sectors],
                     user_roles: %w[admin ict4sdg principle user org_user org_product_user
                                    product_user mni],
                     product_views: ['DIAL OSC', 'Digital Square', 'Unicef', 'Digital Health Atlas'],
                     organization_views: %w[endorser mni product])
end

if PortalView.where(slug: 'projects').count.zero?
  PortalView.create!(name: 'Projects',
                     slug: 'projects',
                     description: 'Projects view',
                     top_navs: %w[products organizations projects],
                     filter_navs: %w[products organizations locations projects],
                     user_roles: %w[admin ict4sdg principle user org_user org_product_user
                                    product_user mni],
                     product_views: ['DIAL OSC', 'Digital Square', 'Unicef', 'Digital Health Atlas'],
                     organization_views: %w[endorser mni product])
end

if PortalView.where(slug: 'playbooks').count.zero?
  PortalView.create!(name: 'Playbooks',
                     slug: 'playbooks',
                     description: 'Playbooks view',
                     top_navs: %w[playbooks plays use_cases products organizations],
                     filter_navs: %w[playbooks plays use_cases products organizations],
                     user_roles: %w[admin ict4sdg principle user org_user org_product_user
                                    product_user mni],
                     product_views: ['DIAL OSC', 'Digital Square', 'Unicef', 'Digital Health Atlas'],
                     organization_views: %w[endorser mni product])
end

if Stylesheet.where(portal: 'default').count.zero?
  Stylesheet.create!(portal: 'default',
                     background_color: '#000043')
end

if Stylesheet.where(portal: 'projects').count.zero?
  Stylesheet.create!(portal: 'projects',
                     background_color: '#430000')
end

if Stylesheet.where(portal: 'playbooks').count.zero?
  Stylesheet.create!(portal: 'playbooks',
                     background_color: '#004300')
end

if Origin.where(slug: 'manually_entered').count.zero?
  Origin.create(name: 'Manually Entered', description: 'Project information are manually entered by user.',
                slug: 'manually_entered')
end

if Endorser.where(slug: 'dpga').count.zero?
  Endorser.create(name: 'Digital Public Goods Alliance',
                  description: 'This product has been screened as a Digital Public Good by the Digital Public '\
                               'Goods Alliance.',
                  slug: 'dpga')
end

if Endorser.where(slug: 'dsq').count.zero?
  Endorser.create(name: 'Digital Square',
                  description: 'This product has been screened as a Global Good by Digital Square.',
                  slug: 'dsq')
end

if Resource.where(slug: 'd4d_handbook').count.zero?
  Resource.create(name: 'D4D Handbook', slug: 'd4d_handbook', phase: 'Planning',
                  image_url: 'https://exchange.dial.global//assets/playbooks/pictures/608/PLAYBOOK_FOR_CATALOG.png',
                  description: 'Comprehensive guide for implementing a D4D program',
                  link: 'https://resources.dial.community/resources/md4d_handbook')
end

if Resource.where(slug: 'procurement_guide').count.zero?
  Resource.create(name: 'DIAL Procurement Guide', slug: 'procurement_guide', phase: 'Planning',
                  image_url: 'https://procurement-digitalimpactalliance.org/wp-content/uploads/2020/11/fotografierende-xqc7hdlmpgk-unsplash.jpg',
                  description: 'Guidance on best practices for Procurement', link: 'https://procurement-digitalimpactalliance.org')
end

if Resource.where(slug: 'roi_toolkit').count.zero?
  Resource.create(name: 'Valuing Impact Toolkit', slug: 'roi_toolkit', phase: 'Evaluation',
                  image_url: 'https://exchange.dial.global/assets/playbooks/pictures/773/Screen_Shot_2021-05-20_at_12.52.30_PM.png',
                  description: 'Tools for measuring Project Impact', link: 'https://resources.dial.community/resources/valuing_impact_toolkit')
end

Dir[Rails.root.join('db/seeds/*.rb')].sort.each do |file|
  puts "Processing #{file.split('/').last}."
  require file
end
