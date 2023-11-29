require 'modules/slugger'
require 'modules/fao'

include Modules::Slugger
include Modules::Fao

namespace :fao do
  task :sync_fao_products, [:tenant] => :environment do |_, params|
    tenant_name = ENV['tenant'].nil? ? 'public' : ENV['tenant']
    puts "TENANT: " + tenant_name
    Apartment::Tenant.switch(tenant_name) do
      task_name = 'Import FAO Products'
      tracking_task_setup(task_name, 'Preparing task tracker record.')
      tracking_task_start(task_name)

      fao_origin = Origin.find_by(name: 'FAO')
      if fao_origin.nil?
        fao_origin = Origin.new
        fao_origin.name = 'FAO'
        fao_origin.slug = 'fao'
        fao_origin.description = 'The Food and Agriculture Organization of the United Nations'

        puts 'FAO as origin is created.' if fao_origin.save!
      end

      dpga_origin = Origin.find_by(name: 'Digital Public Goods Alliance')
      if dpga_origin.nil?
        dpga_origin = Origin.new
        dpga_origin.name = 'Digital Public Goods Alliance'
        dpga_origin.slug = 'dpga'
        dpga_origin.description = 'The Digital Public Goods Alliance (DPGA)'

        puts 'DPGA as origin is created.' if dpga_origin.save!
      end

      dpga_endorser = Endorser.find_by(name: 'Digital Public Goods Alliance')
      if dpga_endorser.nil?
        dpga_endorser = Endorser.new
        dpga_endorser.name = 'Digital Public Goods Alliance'
        dpga_endorser.slug = 'dpga'
        dpga_endorser.description = 'This product has been screened as a Digital Public Good by the Digital Public Goods Alliance.'

        puts 'DPGA as endorser is created.' if dpga_endorser.save!
      end

      fao_organization = Organization.find_by(name: 'Food and Agriculture Organization (FAO) of the United Nations')
      if fao_organization.nil?
        fao_organization = Organization.new
        fao_organization.name = 'Food and Agriculture Organization (FAO) of the United Nations'
        fao_organization.slug = slug_em(fao_organization.name)
        fao_organization.save

        organization_desc = OrganizationDescription.new
        organization_desc.description = 'The Food and Agriculture Organization (FAO) is a specialized agency of the United Nations that leads international efforts to defeat hunger. Our goal is to achieve food security for all and make sure that people have regular access to enough high-quality food to lead active, healthy lives. With 195 members - 194 countries and the European Union, FAO works in over 130 countries worldwide.'
        organization_desc.organization_id = fao_organization.id
        organization_desc.locale = I18n.locale
        organization_desc.save
    

        puts 'FAO as origin is created.' if fao_origin.save!
      end

      tracking_task_log(task_name, 'Parsing csv file.')
      csv_data = CSV.parse(File.read('./utils/FAO_products.csv'), headers: true)

      #csv_data.each_with_index do |fao_product, index|
      csv_data.first(20).each_with_index do |fao_product, index|
        product_name = fao_product[0]
        tracking_task_log(task_name, "Processing product: #{product_name}.")
        sync_fao_product(fao_product, fao_origin, fao_organization)
      end

      tracking_task_finish(task_name)
    end
  end
end
