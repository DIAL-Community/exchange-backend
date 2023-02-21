# frozen_string_literal: true

Product.all.each do |product|
  url = product.website
  next if product.website.nil?

  if url.include?('http://')
    product.website.slice!('http://')
  elsif url.include?('https://')
    product.website.slice!('https://')
  end
  product.save!
end

CandidateProduct.all.each do |candidate|
  url = candidate.website
  next if url.nil?

  if url.include?('http://')
    candidate.website.slice!('http://')
  elsif url.include?('https://')
    candidate.website.slice!('https://')
  end
  candidate.save!
end

Organization.all.each do |organization|
  url = organization.website
  next if url.nil?

  if url.include?('http://')
    organization.website.slice!('http://')
  elsif url.include?('https://')
    organization.website.slice!('https://')
  end
  organization.save!
end

CandidateOrganization.all.each do |candidate|
  url = candidate.website
  next if url.nil?

  if url.include?('http://')
    candidate.website.slice!('http://')
  elsif url.include?('https://')
    candidate.website.slice!('https://')
  end
  candidate.save!
end

Dataset.all.each do |dataset|
  url = dataset.website
  next if url.nil?

  if url.include?('http://')
    dataset.website.slice!('http://')
  elsif url.include?('https://')
    dataset.website.slice!('https://')
  end
  dataset.save!
end

Project.all.each do |project|
  url = project.project_url
  next if url.nil?

  if url.include?('http://')
    project.project_url.slice!('http://')
  elsif url.include?('https://')
    project.project_url.slice!('https://')
  end
  project.save!
end

Resource.all.each do |resource|
  url = resource.link
  next if url.nil?

  if url.include?('http://')
    resource.link.slice!('http://')
  elsif url.include?('https://')
    resource.link.slice!('https://')
  end
  resource.save!
end
