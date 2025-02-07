# frozen_string_literal: true
# rubocop:disable Style/ClassVars

# TODO: Revisit this module to reduce the if nesting.
# Disabling because of this rubocop issue:
# - Avoid more than 3 levels of block nesting. (convention:Metrics/BlockNesting)
# - Replace class var @@product_list with a class instance var. (convention:Style/ClassVars)

require 'resolv-replace'
require 'modules/slugger'
include Modules::Slugger

module Modules
  module Sync
    @@product_list = []
    @@dataset_list = []

    def sync_public_dataset(json_data)
      unless json_data['category'] == 'Open Software'
        puts "Syncing open data: #{json_data['name']}."

        dpga_origin = Origin.find_by(slug: 'dpga')

        name_aliases = [json_data['name']]
        if json_data['aliases'].is_a?(Array)
          json_data['aliases']&.each do |current_alias|
            name_aliases << current_alias.strip unless current_alias.blank?
          end
        end

        existing_dataset = nil
        name_aliases.each do |name_alias|
          # Find by name, and then by aliases and then by slug.
          break unless existing_dataset.nil?

          slug = reslug_em(name_alias)
          existing_dataset = Dataset.first_duplicate(name_alias, slug)
          # Check to see if both just have the same alias. In this case, it's not a duplicate
        end

        is_new = false
        if existing_dataset.nil?
          # Mark this dataset as new one. This means we will use this import as the baseline of the data.
          is_new = true

          existing_dataset = Dataset.new
          existing_dataset.name = name_aliases.first
          existing_dataset.slug = reslug_em(existing_dataset.name)
          @@dataset_list << existing_dataset.name
        end

        website = cleanup_url(json_data['websiteURL'])
        unless website.empty?
          puts "  Updating website: #{existing_dataset.website} => #{website}."
          existing_dataset.website = website
        end

        dataset_type = 'dataset'
        dataset_type = 'ai_model' unless json_data['category'] == 'Open AI Model'
        dataset_type = 'content' unless json_data['category'] == 'Open Data'
        dataset_type = 'content' unless json_data['category'] == 'Open Content'
        dataset_type = 'standard' unless json_data['category'] == 'Open Standard'
        existing_dataset.dataset_type = dataset_type

        # Assign what's left in the alias array as aliases.
        existing_dataset.aliases.concat(name_aliases.reject { |x| x == existing_dataset.name }).uniq!

        if !json_data['openlicenses'].nil? && !json_data['openlicenses'].empty?
          open_license, _ = json_data['openlicenses']
          existing_dataset.license = open_license['openLicense']
        end

        # Set the origin to be 'DPGA'
        if !dpga_origin.nil? && !existing_dataset.origins.exists?(id: dpga_origin.id)
          existing_dataset.origins.push(dpga_origin)
        end

        if !json_data['sectors'].nil? && !json_data['sectors'].empty?
          json_data['sectors'].each do |sector|
            sector_obj = Sector.find_by(name: sector)
            # Check to see if the sector exists already
            if !sector_obj.nil? && !existing_dataset.sectors.include?(sector_obj)
              puts "  Adding sector #{sector_obj.name} to dataset."
              existing_dataset.sectors << sector_obj
            else
              puts "  Unable to find sector: #{sector}."
            end
          end
        end

        if !json_data['sdgs'].nil?
          json_data['sdgs'].each do |sdg_entry|
            sdg_number = sdg_entry['number'].to_i

            sdg = SustainableDevelopmentGoal.find_by(number: sdg_number)
            next if sdg.nil?

            dataset_sdg = DatasetSustainableDevelopmentGoal.find_by(
              dataset_id: existing_dataset.id,
              sustainable_development_goal_id: sdg.id
            )
            dataset_sdg = DatasetSustainableDevelopmentGoal.new if dataset_sdg.nil?
            dataset_sdg.sustainable_development_goal_id = sdg.id
            dataset_sdg.mapping_status = DatasetSustainableDevelopmentGoal.mapping_status_types[:VALIDATED]

            existing_dataset.dataset_sustainable_development_goals << dataset_sdg
          end
        end

        organization_entries = json_data['organizations']
        if !organization_entries.nil? && !organization_entries.empty?
          organization_entries.each do |organization_entry|
            organization = Organization.find_by(name: organization_entry['name'])
            next if organization.nil?

            organization_dataset = OrganizationDataset.find_by(
              dataset_id: existing_dataset.id,
              organization_id: organization.id,
              organization_type: organization_entry['org_type']
            )

            organization_dataset = OrganizationDataset.new if organization_dataset.nil?
            organization_dataset.organization_id = organization.id
            organization_dataset.organization_type = organization_entry['org_type']

            existing_dataset.organizations_datasets << organization_dataset
          end
        end

        deployment_countries = json_data['deploymentCountries']
        if !deployment_countries.nil? && !deployment_countries.empty?
          deployment_countries.each do |deployment_country|
            country = Country.find_by(name: deployment_country)
            next if country.nil?

            existing_dataset.countries << country unless existing_dataset.countries.include?(country)
          end
        end

        ActiveRecord::Base.transaction do
          if is_new || !existing_dataset.manual_update
            existing_dataset.save!
            puts "  Dataset #{existing_dataset.name} saved."

            # Moving descriptions from product to dataset's description table.
            dataset_description = DatasetDescription.new
            dataset_description.locale = 'en'
            dataset_description.dataset = existing_dataset
            dataset_description.description = json_data['description']

            dataset_description.save!
            puts "  Adding description for locale: #{dataset_description.locale}."
          end
        end
      end
    end

    def sync_public_product(json_data)
      if json_data['categories'] == 'Open Software'
        puts "Syncing product: #{json_data['name']}."

        dpga_origin = Origin.find_by(slug: 'dpga')
        dpga_endorser = Endorser.find_by(slug: 'dpga')

        name_aliases = [json_data['name']]
        if json_data['aliases'].is_a?(Array)
          json_data['aliases']&.each do |current_alias|
            name_aliases << current_alias.strip unless current_alias.blank?
          end
        end

        existing_product = nil
        name_aliases.each do |name_alias|
          # Find by name, and then by aliases and then by slug.
          break unless existing_product.nil?

          slug = reslug_em(name_alias)
          existing_product = Product.first_duplicate(name_alias, slug)
          # Check to see if both just have the same alias. In this case, it's not a duplicate
        end

        if existing_product.nil?
          # Check to see if it is a child product (ie. it already has a repository)
          product_repository = ProductRepository.find_by(slug: reslug_em("#{json_data['name']} Repository"))
          return unless product_repository.nil?

          existing_product = Product.new
          existing_product.name = name_aliases.first
          existing_product.slug = reslug_em(existing_product.name)
          @@product_list << existing_product.name
        end

        website = cleanup_url(json_data['websiteURL'])
        unless website.empty?
          puts "  Updating website: #{existing_product.website} => #{website}."
          existing_product.website = website
        end

        # Assign what's left in the alias array as aliases.
        existing_product.aliases.concat(name_aliases.reject { |x| x == existing_product.name }).uniq!

        # Set the origin to be 'DPGA'
        if !dpga_origin.nil? && !existing_product.origins.exists?(id: dpga_origin.id)
          existing_product.origins.push(dpga_origin)
        end

        if !json_data['sdgs'].nil?
          json_data['sdgs'].each do |sdg_entry|
            sdg_number = sdg_entry['number'].to_i

            sdg = SustainableDevelopmentGoal.find_by(number: sdg_number)
            next if sdg.nil?

            product_sdg = ProductSustainableDevelopmentGoal.find_by(
              product_id: existing_product.id,
              sustainable_development_goal_id: sdg.id
            )

            product_sdg = ProductSustainableDevelopmentGoal.new if product_sdg.nil?
            product_sdg.sustainable_development_goal_id = sdg.id
            product_sdg.mapping_status = DatasetSustainableDevelopmentGoal.mapping_status_types[:VALIDATED]

            existing_product.product_sustainable_development_goals << product_sdg
          end
        end

        if !json_data['sectors'].nil? && !json_data['sectors'].empty?
          json_data['sectors'].each do |sector|
            sector_obj = Sector.find_by(name: sector)
            # Check to see if the sector exists already
            if !sector_obj.nil? && !existing_product.sectors.include?(sector_obj)
              puts "  Adding sector #{sector_obj.name} to product"
              existing_product.sectors << sector_obj
            else
              puts "  Unable to find sector: #{sector}"
            end
          end
        end

        if json_data['stage'] == 'DPG' && !existing_product.endorsers.include?(dpga_endorser)
          existing_product.endorsers << dpga_endorser
        end

        deployment_countries = json_data['locations']['deploymentCountries']
        if !deployment_countries.nil? && !deployment_countries.empty?
          deployment_countries.each do |deployment_country|
            country = Country.find_by(name: deployment_country)
            next if country.nil?

            existing_product.countries << country unless existing_product.countries.include?(country)
          end
        end

        ActiveRecord::Base.transaction do
          existing_product.save
          puts "  Product #{existing_product.name} saved."

          update_product_description(json_data, existing_product) unless existing_product.manual_update
          update_product_organizations(json_data, existing_product)
        end
      end
    end

    def sync_digisquare_product(digi_product, digisquare_maturity)
      dsq_endorser = Endorser.find_by(slug: 'dsq')
      digisquare_origin = Origin.find_by(slug: 'digital-square')

      name_aliases = [digi_product['name']]
      digi_product['aliases']&.each do |name_alias|
        name_aliases.push(name_alias)
      end

      existing_product = nil
      name_aliases.each do |name_alias|
        # Find by name, and then by aliases and then by slug.
        break unless existing_product.nil?

        slug = reslug_em(name_alias)
        existing_product = Product.first_duplicate(name_alias, slug)
      end

      if existing_product.nil?
        existing_product = Product.new
        existing_product.name = digi_product['name']
        existing_product.slug = reslug_em(digi_product['name'])
        existing_product.save
        @@product_list << existing_product.name
      end

      unless existing_product.origins.exists?(id: digisquare_origin.id)
        existing_product.origins.push(digisquare_origin)
      end

      website = cleanup_url(digi_product['website'])
      unless website.empty?
        puts "  Updating website: #{existing_product.website} => #{website}."
        existing_product.website = website
      end

      sdg_entries = digi_product['SDGs']
      if !sdg_entries.nil? && !sdg_entries.empty?
        sdg_entries.each do |sdg_entry|
          sdg = SustainableDevelopmentGoal.find_by(number: sdg_entry)
          next if sdg.nil?

          unless existing_product.id.nil?
            product_sdg = ProductSustainableDevelopmentGoal.find_by(
              product_id: existing_product.id,
              sustainable_development_goal_id: sdg.id
            )
            next unless product_sdg.nil?
          end

          product_sdg = ProductSustainableDevelopmentGoal.new
          product_sdg.sustainable_development_goal_id = sdg.id
          product_sdg.mapping_status = DatasetSustainableDevelopmentGoal.mapping_status_types[:VALIDATED]

          existing_product.product_sustainable_development_goals << product_sdg
        end
      end

      ActiveRecord::Base.transaction do
        existing_product.save
        # This will update website, license, repo URL, organizations, and SDGs
        update_product_organizations(digi_product, existing_product)

        # Find maturity data if it exists and update
        digisquare_maturity.each do |ds_maturity|
          next if existing_product.name.downcase != ds_maturity['name'].downcase

          ds_maturity['maturity'].each do |key, value|
            # Find the correct category and indicator
            categories = RubricCategory.all.map(&:id)
            category_indicator = CategoryIndicator.find_by(rubric_category: categories, name: key)

            # Save the value in ProductIndicators
            product_indicator = ProductIndicator.find_by(product_id: existing_product.id,
                                                         category_indicator_id: category_indicator.id)
            product_indicator = ProductIndicator.new if product_indicator.nil?

            product_indicator.indicator_value = value
            product_indicator.product_id = existing_product.id
            product_indicator.category_indicator_id = category_indicator.id
            product_indicator.save
          end
        end

        unless existing_product.endorsers.include?(dsq_endorser)
          existing_product.endorsers << dsq_endorser
        end

        existing_product.save

        update_product_description(digi_product, existing_product) unless existing_product.manual_update
        puts "Product updated: #{existing_product.name} -> #{existing_product.slug}."
        puts "--------"
      end
    end

    def sync_json_product(product)
      puts "Syncing #{product['name']}."
      name_aliases = [product['name']]
      product['aliases']&.each do |name_alias|
        name_aliases.push(name_alias)
      end

      existing_product = nil
      name_aliases.each do |name_alias|
        # Find by name, and then by aliases and then by slug.
        break unless existing_product.nil?

        slug = reslug_em(name_alias)
        existing_product = Product.first_duplicate(name_alias, slug)
      end

      if existing_product.nil?
        existing_product = Product.new
        existing_product.name = product['name']
        existing_product.slug = reslug_em(product['name'])
        @@product_list << existing_product.name
      end

      website = cleanup_url(product['website'])
      unless website.empty?
        puts "  Updating website: #{existing_product.website} => #{website}."
        existing_product.website = website
      end

      # This will update website, license, repo URL, organizations, and SDGs
      update_product_organizations(product, existing_product)

      sdg_entries = product['SDGs']
      if !sdg_entries.nil? && !sdg_entries.empty?
        sdg_entries.each do |sdg_entry|
          sdg = SustainableDevelopmentGoal.find_by(number: sdg_entry)
          next if sdg.nil?

          unless existing_product.id.nil?
            product_sdg = ProductSustainableDevelopmentGoal.find_by(
              product_id: existing_product.id,
              sustainable_development_goal_id: sdg.id
            )
            next unless product_sdg.nil?
          end

          product_sdg = ProductSustainableDevelopmentGoal.new
          product_sdg.sustainable_development_goal_id = sdg.id
          product_sdg.mapping_status = DatasetSustainableDevelopmentGoal.mapping_status_types[:VALIDATED]

          existing_product.product_sustainable_development_goals << product_sdg
        end
      end

      json_origin = Origin.find_by(slug: 'dial')
      unless existing_product.origins.exists?(id: json_origin.id)
        existing_product.origins.push(json_origin)
      end

      ActiveRecord::Base.transaction do
        existing_product.save
        puts "  Added new product: #{existing_product.name} -> #{existing_product.slug}"
        update_product_description(product, existing_product) unless existing_product.manual_update
      end
    end

    def search_in_ignorelist(json_data, ignore_list)
      skipping_entry = false
      ignore_list.each do |ignored|
        skipping_entry = (json_data['name'] == ignored['item'])
        break if skipping_entry
      end
      skipping_entry
    end

    def repository_counter_text(index)
      counter_texts = [
        'first',
        'second',
        'third',
        'fourth',
        'fifth',
        'sixth',
        'seventh',
        'eighth',
        'ninth',
        'tenth',
        'eleventh',
        'twelfth',
        'thirteenth',
        'fourteenth',
        'fifteenth',
        'sixteenth',
        'seventeenth',
        'eighteenth',
        'nineteenth',
        'twentieth'
      ]
      counter_texts[index]
    end

    def sync_repository_data(json_data)
      product_name = json_data['name']
      existing_product = Product.first_duplicate(product_name, reslug_em(product_name))

      # Do nothing if product is not exists or product have been manually updated
      return if existing_product.nil? || existing_product.manual_update

      # This section is used for Digi Square and OSC sync
      unless json_data['repositoryUrl'].nil?
        product_repository = ProductRepository.find_by(absolute_url: cleanup_url(json_data['repositoryUrl'].to_s))
        product_repository = ProductRepository.new if product_repository.nil?

        repository_name = [product_name, 'Repository'].join(' ')
        puts "  Creating repository for: #{product_name} => #{json_data['repositoryUrl']}."
        repository_attrs = {
          name: repository_name,
          slug: reslug_em(repository_name),
          absolute_url: cleanup_url(json_data['repositoryUrl'].to_s),
          description: "Main code repository of #{product_name}.",
          main_repository: true
        }
        repository_attrs[:product] = existing_product

        unless json_data['license'].nil?
          puts "  Adding license for: #{repository_attrs[:name]} => #{json_data['license']}."
          repository_attrs[:license] = json_data['license']
        end
        product_repository.update(repository_attrs)
      end

      # DPGA now lists multiple repositories
      repositories = json_data['repositories']
      repositories&.each do |current_repository|
        repository_urls = current_repository['url'].to_s.split(',')
        repository_urls.each_with_index do |repository_url, index|
          product_repository = ProductRepository.find_by(
            absolute_url: cleanup_url(repository_url.to_s.strip)
          )
          product_repository = ProductRepository.find_by(
            absolute_url: repository_url.to_s.strip
          ) if product_repository.nil?

          product_repository = ProductRepository.new if product_repository.nil?

          repository_name = [product_name, repository_counter_text(index), 'Repository'].join(' ')
          puts "  Creating repository for: '#{repository_name.titlecase}'."
          repository_attrs = {
            name: repository_name.titlecase,
            slug: reslug_em(repository_name),
            absolute_url: cleanup_url(repository_url.to_s.strip),
            description: "#{repository_counter_text(index).titlecase} code repository of #{product_name}.",
            main_repository: true
          }
          repository_attrs[:product] = existing_product

          if !json_data['openlicenses'].nil? && !json_data['openlicenses'].empty?
            open_license, _ = json_data['openlicenses']
            puts "  Updating license for: #{product_repository.name} => #{open_license['openLicense']}."
            repository_attrs[:license] = open_license['openLicense']
          end

          product_repository.update(repository_attrs)
        end
      end
    end

    def update_product_organizations(json_data, existing_product)
      organization_entries = json_data['organizations']
      if !organization_entries.nil? && !organization_entries.empty?
        organization_entries.each do |organization_entry|
          organization_name = organization_entry['name'].gsub('\'', '')
          organization = Organization.find_by(
            "LOWER(name) = LOWER(?) OR slug = ? OR aliases @> ARRAY['#{organization_name}']::varchar[]",
            organization_name,
            reslug_em(organization_name)
          )
          if organization.nil?
            # Create a new organization and assign it as an owner
            organization = Organization.new
            organization.name = organization_name
            organization.slug = reslug_em(organization_name, 128)
            organization.website = cleanup_url(organization['website'])
            organization.save

            organization_product = OrganizationProduct.new
            organization_product.organization_type = organization['org_type']
            organization_product.organization_id = organization.id
            organization_product.product_id = existing_product.id
            organization_product.save
          else
            organization.website = cleanup_url(organization['website'])
            organization.name = organization_name
            organization.save
          end

          next if existing_product.organizations.include?(organization)

          puts "  Adding organization to product: #{organization.name}."
          organization_product = OrganizationProduct.new
          organization_product.organization_type = organization['org_type']
          organization_product.organization_id = organization.id
          organization_product.product_id = existing_product.id
          organization_product.save
        end
      end
    end

    def sync_giz_project(english_project, german_project, giz_origin)
      puts "Processing data: '#{english_project[0]}'."
      # Expected csv columns:
      # Project Name:                           A - 0 - Title
      # Project Description:                    F - 5 - Description
      # Project Start Date:                     M - 12 - Start Date
      # Project End Date:                       N - 13 - End Date
      # Project URL:                            AM - 38 - Links
      # Project Sectors:
      #   Main sectors:                         V - 21 - Main Sector
      #   Additional sectors:                   X - 23 - Additional Sectors
      #   Main subsectors:                      W - 22 - Main subsectors
      #   Main subsectors:                      Y - 24 - Additional subsectors
      # Project SDGs                            Z - 25 - Sustainable Development Goals
      # Principles of Digital Development       AO...AW - 40-48

      # Create sector if it does not exist
      subsector_names = [english_project[22], english_project[23], english_project[24]].join(', ')
      english_sectors = read_sector(english_project[21], subsector_names, 'en')
      german_sectors = []

      # Create new project or update existing project
      project_name = english_project[0]
      project_slug = reslug_em(project_name, 64)

      existing_project = Project.name_and_slug_search(project_name, project_slug).first
      existing_project = Project.new if existing_project.nil?

      existing_project.name = project_name.force_encoding('UTF-8')
      existing_project.slug = project_slug
      existing_project.origin_id = giz_origin.id

      begin
        existing_project.start_date = Date.strptime(english_project[12], '%m/%Y')
      rescue StandardError
        puts "  Unable to parse project start date."
      end

      begin
        existing_project.end_date = Date.strptime(english_project[13], '%m/%Y')
      rescue StandardError
        puts " Unable to parse project end date."
      end

      en_more_urls = '<hr />'
      de_more_urls = '<hr />'
      unless english_project[38].nil?
        project_urls = english_project[38].split(', ')
        main_url, *other_urls = *project_urls

        existing_project.project_url = cleanup_url(main_url)

        if other_urls.length.positive?
          en_more_urls += '<p>Other urls</p>'
          de_more_urls += '<p>Mehr urls</p>'

          en_more_urls += '<ul">'
          de_more_urls += '<ul">'
          other_urls.each do |other_url|
            en_more_urls += "<li>#{other_url}</li>"
            de_more_urls += "<li>#{other_url}</li>"
          end
          en_more_urls += '</ul">'
          de_more_urls += '</ul">'
        end
      end

      existing_project.save!

      # Assign implementing organization
      implementer_organizations = Organization.name_contains(english_project[5])

      if !implementer_organizations.empty? && !existing_project.organizations.include?(implementer_organizations.first)
        project_organization = ProjectOrganization.new
        project_organization.organization_type = 'implementer'
        project_organization.project_id = existing_project.id
        project_organization.organization_id = implementer_organizations.first.id
        project_organization.save
      end

      # Clear sectors
      existing_project.sectors = []

      # Assign to sectors
      english_sectors.each do |sector_id|
        sector = Sector.find(sector_id)
        existing_project.sectors << sector unless existing_project.sectors.include?(sector)
      end

      german_sectors.each do |sector_id|
        sector = Sector.find(sector_id)
        existing_project.sectors << sector unless existing_project.sectors.include?(sector)
      end

      # Assign tags
      unless subsector_names.nil?
        existing_tags = []
        project_tags = subsector_names.gsub(/\s*\(.+\)/, '').split(',').map(&:strip)
        project_tags.each do |project_tag|
          tag = Tag.find_by(slug: reslug_em(project_tag))
          existing_tags << tag.name unless tag.nil?
        end
        existing_project.tags = existing_tags
      end

      # Assign to SDGs
      unless english_project[25].nil?
        sdg_list = english_project[25].sub('Peace, Justice', 'Peace Justice')
                                      .sub('Reduced Inequality', 'Reduced Inequalities')
                                      .sub('Industry, Innovation, and', 'Industry Innovation and')
        sdg_names = sdg_list.split(',')
        sdg_names.each do |sdg_name|
          sdg_slug = reslug_em(sdg_name.strip)
          sdg = SustainableDevelopmentGoal.find_by(slug: sdg_slug)
          unless sdg.nil? || existing_project.sustainable_development_goals.include?(sdg)
            existing_project.sustainable_development_goals << sdg
          end
        end
      end

      # Assign to locations
      country_names = english_project[15].to_s.split(',')
      country_names.each do |country_name|
        country = Country.find_by(name: country_name.strip)
        next if country.nil?

        existing_project.countries << country unless existing_project.countries.include?(country)
        # Add any German aliases to the country
      end

      # Create both English and German descriptions
      project_description = ProjectDescription.find_by(project_id: existing_project.id, locale: 'en')
      project_description = ProjectDescription.new if project_description.nil?

      project_description.project_id = existing_project.id
      english_project[3] = 'No description.' if english_project[5].blank? && en_more_urls.blank?
      project_description.description = "#{english_project[5]}#{en_more_urls}"
      project_description.locale = 'en'
      project_description.save

      project_description = ProjectDescription.find_by(project_id: existing_project.id, locale: 'de')
      project_description = ProjectDescription.new if project_description.nil?

      project_description.project_id = existing_project.id
      german_project[3] = 'Kein description.' if german_project[5].blank? && de_more_urls.blank?
      project_description.description = "#{german_project[5]}#{de_more_urls}"
      project_description.locale = 'de'
      project_description.save

      # Create links to Digital Principles
      principles = DigitalPrinciple.all.order(:id)
      (40..48).each do |principle_col|
        principle_index = principle_col - 40
        next unless english_project[principle_col] == '1'

        unless existing_project.digital_principles.include?(principles[principle_index])
          existing_project.digital_principles << principles[principle_index]
        end
      end

      existing_project.save!
      puts "-----------"
    end

    def read_sector(sector_name, subsector_names, locale)
      sector_map = File.read('data/json/sector-map.json')
      sector_json = JSON.parse(sector_map)

      sector_array = []

      sector_name = sector_name.to_s.strip
      sector_slug = reslug_em(sector_name)
      existing_sector = Sector.find_by(
        'slug like ? and locale = ? and is_displayable is true and parent_sector_id is null',
        "%#{sector_slug}%",
        locale
      )

      sector_array << existing_sector.id unless existing_sector.nil?

      if existing_sector.nil?
        puts "  Add sector to map: '#{sector_slug}'." if sector_json[sector_slug].nil?
        unless sector_json[sector_slug].nil?
          existing_sector = Sector.find_by(
            'slug like ? and locale = ? and is_displayable is true',
            "%#{sector_json[sector_slug]}%",
            locale
          )
          sector_array << existing_sector.id unless existing_sector.nil?
        end
      end

      return sector_array if subsector_names.nil?

      subsector_array = subsector_names.split(',')
      subsector_array.each do |subsector|
        next if subsector.blank?

        subsector = subsector.strip
        subsector_slug = reslug_em(subsector, 64)
        existing_subsector = Sector.find_by(
          'slug like ? and parent_sector_id = ? and locale = ? and is_displayable is true',
          "%#{subsector_slug}%",
          existing_sector.id,
          locale
        )

        sector_array << existing_subsector.id unless existing_subsector.nil?
        next unless existing_subsector.nil?

        puts "  Add subsector to map: '#{subsector_slug}'." if sector_json[subsector_slug].nil?
        next if sector_json[subsector_slug].nil?

        existing_subsector = Sector.find_by(
          'slug like ? and parent_sector_id = ? and locale = ? and is_displayable is true',
          "%#{sector_json[subsector_slug]}%",
          existing_sector.id,
          locale
        )
        sector_array << existing_subsector.id unless existing_subsector.nil?
      end
      sector_array
    end

    def cleanup_url(maybe_url)
      cleaned_url = ''
      unless maybe_url.blank?
        cleaned_url = maybe_url.strip
                               .sub(/^https?:\/\//i, '')
                               .sub(/^https?\/\/:/i, '')
                               .sub(/\/$/, '')
      end
      cleaned_url
    end

    def update_product_description(json_data, existing_product)
      description_entry = json_data['description']

      product_description = ProductDescription.find_by(product_id: existing_product, locale: I18n.locale)
      product_description = ProductDescription.new if product_description.nil?

      product_description.product_id = existing_product.id
      product_description.locale = I18n.locale

      return unless product_description.description.blank?

      if !description_entry.blank?
        product_description.description = description_entry
      else
        yaml_descriptions = YAML.load_file('data/yaml/product-description.yml')
        yaml_descriptions['products'].each do |yaml_description|
          if existing_product.slug == yaml_description['slug']
            product_description.description = yaml_description['description']
            puts "  Assigning description from yml for: #{existing_product.slug}."
          end
        end
        product_description.description = '' if product_description.description.nil?
      end

      product_description.save
      puts "  Product description updated: #{existing_product.name} -> #{existing_product.slug}."
    end

    def update_tco_data(product_repository)
      return if product_repository.absolute_url.blank?

      # We can't process Gitlab repos currently, so ignore those
      return if product_repository.absolute_url.include?('gitlab')
      return if product_repository.absolute_url.include?('AsTeR')

      puts "Processing: #{product_repository.absolute_url}."
      command = "./cloc-git.sh #{product_repository.absolute_url}"
      stdout, = Open3.capture3(command)

      return if stdout.blank?

      code_data = CSV.parse(File.read('./repodata.csv'), headers: true)
      code_data.each do |code_row|
        next unless code_row['language'] == 'SUM'

        puts "Number of lines : #{code_row['code']}"
        product_repository.code_lines = code_row['code'].to_i

        # COCOMO Calculation is Effort = A * (Lines of Code/1000)^B
        # A and B are based on project complexity. We are using simple, where A=2.4 and B=1.05
        total_klines = code_row['code'].to_i / 1000
        effort = 2.4 * total_klines**1.05

        product_repository.cocomo = effort.round.to_s
        puts "Product effort: #{effort.round}."
        puts "Product repository #{product_repository.name} COCOMO data saved." if product_repository.save!
      end
    end

    def send_notification
      unless @@product_list.empty?
        admin_users = User.where(receive_backup: true)
        email_body = "New product(s) added by the nightly sync process: <br />#{@@product_list.join('<br />')}."
        admin_users.each do |user|
          RakeMailer.sync_product_added(user.email, email_body).deliver_now
        end
        @@product_list.clear
      end
    end

    def export_products(source)
      # session = ActionDispatch::Integration::Session.new(Rails.application)
      # session.get "/productlist?source="+source
      server_uri = URI.parse("https://exchange.dial.global/productlist?source=#{source}")

      response = Net::HTTP.get(server_uri)
      product_list = JSON.parse(response)
      product_list.each do |product|
        publicgoods_name = product['publicgoods_name']
        if publicgoods_name.nil?
          publicgoods_name = product['name']
          puts "New Product: #{publicgoods_name}."
        end
        product.except!('aliases') if product['aliases'].nil?
        product.except!('publicgoods_name')
        puts "Sector List: #{product['sectors']}."
        product['name'] = publicgoods_name
        json_string = JSON.pretty_generate(product)
        regex = /(?<content>"(?:[^\\"]|\\.)+")|(?<open>\{)\s+(?<close>\})|(?<open>\[)\s+(?<close>\])/m
        json_string = json_string.gsub(regex, '\k<open>\k<content>\k<close>')
        json_string += "\n"
        File.open("export/#{reslug_em(publicgoods_name, 100).gsub('_', '-')}.json", 'w') do |f|
          f.write(json_string)
        end
      end
    end
  end
end
# rubocop:enable Style/ClassVars
