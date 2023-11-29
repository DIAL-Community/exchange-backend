# frozen_string_literal: true
module Modules
  module Fao
    def sync_fao_product(fao_product, fao_origin, fao_organization)
      puts "Processing data: '#{fao_product[0]}'."
      # Expected csv columns:
      # Product Name (0):                       Title
      # Official Name/Alises (1&2):             Official Name/Also Known As
      # Product URL (3):                        URL
      # Logo URL (4):                           Logo URL - automatically upload
      # Category (6):                           Use Extra Attributes field
      # Asset Type (7):                         Use Extra Attributes field
      # FAO Owned (8):                          If yes, assign FAO as organization
      # Description (9):                        Description
      # 4Words (11):                            Add as summary at bottom of description?? Or Extra Attributes field
      # Responsible Organization (12):          Create if needed and assign as organization
      # Verified Country deployments (13):      Assign products directly to countries (can use for DPGA sync as well)
      # Product Stage (16):                     Use extra attributes field
      # Use Cases Supported                     Look up existing use cases and assign
      # Documentation URL (20):                 Extra Attributes field
      # DPG Status (21):                        If approved, add DPG as origin and endorser
      # Instance of                             Use Includes field
      # Dependencies                            Use Interoperates field

      # Sector assignment?

      # Create new product or update existing product
      product_name = fao_product[0]
      product_slug = slug_em(product_name, 64)

      existing_product = Product.name_and_slug_search(product_name, product_slug).first
      existing_product = Product.new if existing_product.nil?

      existing_product.name = product_name.force_encoding('UTF-8')
      existing_product.slug = product_slug
      existing_product.origins << fao_origin unless existing_product.origins.include?(fao_origin)

      existing_product.aliases << fao_product[1] unless fao_product[1].blank?
      # To-Do - Also-Known-As

      existing_product.website = fao_product[3] unless fao_product[3].blank?
      unless fao_product[4].blank?
        upload_user = User.find_by(username: 'admin')
        begin
          image_file = URI.parse(fao_product[4]).open
          uploader = LogoUploader.new(existing_product, fao_product[4], upload_user)
          uploader.store!(image_file)
        rescue StandardError => e
          puts "Unable to save image for: #{existing_product.name}. Standard error: #{e}."
        end
      end

      extra_attributes = []
      extra_attributes << { 'name': 'Category', 'value': fao_product[6] } unless fao_product[6].blank?
      extra_attributes << { 'name': 'Asset Type', 'value': fao_product[7] } unless fao_product[7].blank?
      extra_attributes << { 'name': 'Documentation URL', 'value': fao_product[20] } unless fao_product[20].blank?
      extra_attributes << { 'name': 'Product Stage', 'value': fao_product[16] } unless fao_product[16].blank?
      existing_product.extra_attributes = extra_attributes

      existing_product.save!

      # Create description
      product_description = ProductDescription.find_by(product_id: existing_product.id, locale: 'en')
      product_description = ProductDescription.new if product_description.nil?

      fao_desc = 'No description.' if fao_product[9].blank?
      fao_desc = '<p>' + fao_product[9] + '</p>' unless fao_product[9].blank?
      fao_desc += '<br /><p>Summary: ' + fao_product[11] + '</p>' unless fao_product[11].blank?
      product_description.product_id = existing_product.id
      product_description.description = fao_desc
      product_description.locale = 'en'
      product_description.save

      if fao_product[8].downcase == 'yes' && !existing_product.organizations.include?(fao_organization)
        product_organization = OrganizationsProduct.new
        product_organization.org_type = 'owner'
        product_organization.product_id = existing_product.id
        product_organization.organization_id = fao_organization.id
        product_organization.save
      end

      unless fao_product[12].blank?
        organization_name = fao_product[12].gsub('\'', '')
        organization = Organization.find_by(
          "LOWER(name) = LOWER(?) OR slug = ? OR aliases @> ARRAY['#{organization_name}']::varchar[]",
          organization_name,
          slug_em(organization_name)
        )
        if organization.nil?
          # Create a new organization and assign it as an owner
          organization = Organization.new
          organization.name = organization_name
          organization.slug = slug_em(organization_name, 128)
          organization.website = cleanup_url(organization['website'])
          organization.save
        end

        unless existing_product.organizations.include?(organization)
          puts "  Adding organization to product: #{organization.name}."
          organization_product = OrganizationsProduct.new
          organization_product.org_type = organization['org_type']
          organization_product.organization_id = organization.id
          organization_product.product_id = existing_product.id
          organization_product.save
        end
      end

      # Assign to locations
      country_names = fao_product[13].to_s.split(';')
      country_names.each do |country_name|
        country = Country.find_by(name: country_name.gsub('#', '').strip)
        next if country.nil?

        existing_product.countries << country
      end

      if !fao_product[21].nil? && fao_product[21].downcase == 'approved'
        dpga_origin = Origin.find_by(name: 'Digital Public Goods Alliance')
        dpga_endorser = Endorser.find_by(name: 'Digital Public Goods Alliance')

        unless existing_product.endorsers.include?(dpga_endorser)
          existing_product.origins << dpga_origin
          existing_product.endorsers << dpga_endorser
        end
      end

      existing_product.save!
      puts "-----------"
    end
  end
end
