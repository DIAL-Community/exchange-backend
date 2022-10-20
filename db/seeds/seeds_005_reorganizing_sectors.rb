# frozen_string_literal: true
require 'modules/slugger'

# Migrate 'Other: Supply Chain and Logistics' to 'Supply Chain and Logistics'.
current_sector_slug = slug_em('Other: Supply Chain and Logistics')
updated_sector_slug = slug_em('Supply Chain and Logistics')

sectors_to_update = Sector.where(slug: current_sector_slug)
sectors_to_update.each do |sector_to_update|
  _, name = sector_to_update.name.split(':')

  sector_to_update.slug = updated_sector_slug
  sector_to_update.name = name.strip
  sector_to_update.parent_sector_id = nil

  if sector_to_update.save
    puts "Updated sector name to '#{name.strip}'."
  end
end

# Iterate over child sectors and re-assign parent of the child sectors
# Affected tables:
# - "dataset_sectors"
# - "organizations_sectors"
# - "playbooks_sectors"
# - "product_sectors"
# - "projects_sectors"
# - "sectors"
# - "use_cases"
child_sectors = Sector.where.not(parent_sector_id: nil)
puts "Child sectors length: #{child_sectors.size}."

child_sectors.each do |child_sector|
  parent_sector = child_sector.parent_sector

  puts "Removing child sector: #{child_sector.name}."
  puts "Adding parent sector if needed: #{parent_sector.name}."

  counter = 0
  datasets = Dataset.joins(:sectors).where(sectors: { id: child_sector.id })
  datasets.each do |dataset|
    dataset.sectors.destroy(child_sector)
    dataset.sectors.destroy(parent_sector)

    dataset.sectors << parent_sector
    counter += 1
  end
  puts "#{counter} #{'dataset'.pluralize(counter)} updated."

  counter = 0
  organizations = Organization.joins(:sectors).where(sectors: { id: child_sector.id })
  organizations.each do |organization|
    organization.sectors.destroy(child_sector)
    organization.sectors.destroy(parent_sector)

    organization.sectors << parent_sector
    counter += 1
  end
  puts "#{counter} #{'organization'.pluralize(counter)} updated."

  counter = 0
  playbooks = Playbook.joins(:sectors).where(sectors: { id: child_sector.id })
  playbooks.each do |playbook|
    playbook.sectors.destroy(child_sector)
    playbook.sectors.destroy(parent_sector)

    playbook.sectors << parent_sector
    counter += 1
  end
  puts "#{counter} #{'playbook'.pluralize(counter)} updated."

  counter = 0
  products = Product.joins(:sectors).where(sectors: { id: child_sector.id })
  products.each do |product|
    product.sectors.destroy(child_sector)
    product.sectors.destroy(parent_sector)

    product.sectors << parent_sector
    counter += 1
  end
  puts "#{counter} #{'product'.pluralize(counter)} updated."

  counter = 0
  projects = Project.joins(:sectors).where(sectors: { id: child_sector.id })
  projects.each do |project|
    project.sectors.destroy(child_sector)
    project.sectors.destroy(parent_sector)

    project.sectors << parent_sector
    counter += 1
  end
  puts "#{counter} #{'project'.pluralize(counter)} updated."

  counter = 0
  use_cases = UseCase.where(sector_id: child_sector.id)
  use_cases.each do |use_case|
    use_case.sector_id = parent_sector.id
    if use_case.save
      counter += 1
    end
  end
  puts "#{counter} #{'use case'.pluralize(counter)} updated."

  if child_sector.destroy
    puts "Sector: #{child_sector.name} deleted."
    puts "-----------------"
  end
end

# Remove hidden sectors.
hidden_sectors = Sector.where(is_displayable: false)
puts "Hidden sectors length: #{hidden_sectors.size}."
deleted_sectors = hidden_sectors.destroy_all
unless deleted_sectors.empty?
  puts "Hidden #{'sector'.pluralize(deleted_sectors.size)} deleted."
end
