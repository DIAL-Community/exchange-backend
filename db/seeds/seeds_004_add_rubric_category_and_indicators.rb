# frozen_string_literal: true

require 'modules/slugger'

active_maintenance_category = RubricCategory.find_by(slug: slug_em('Active Maintenance'))
if active_maintenance_category.nil?
  active_maintenance_category = RubricCategory.new(
    name: 'Active Maintenance',
    slug: slug_em('Active Maintenance'),
    weight: 1
  )
  active_maintenance_category.save
end

software_usage_category = RubricCategory.find_by(slug: slug_em('Software Usage'))
if software_usage_category.nil?
  software_usage_category = RubricCategory.new(
    name: 'Software Usage',
    slug: slug_em('Software Usage'),
    weight: 1
  )
  software_usage_category.save
end

community_health_category = RubricCategory.find_by(slug: slug_em('Community Health'))
if community_health_category.nil?
  community_health_category = RubricCategory.new(
    name: 'Community Health',
    slug: slug_em('Community Health'),
    weight: 1
  )
  community_health_category.save
end

review_category = RubricCategory.find_by(slug: slug_em('Code Review'))
if review_category.nil?
  review_category = RubricCategory.new(
    name: 'Code Review',
    slug: slug_em('Code Review'),
    weight: 1
  )
  review_category.save
end

community_support_category = RubricCategory.find_by(slug: slug_em('Community Support'))
if community_support_category.nil?
  community_support_category = RubricCategory.new(
    name: 'Community Support',
    slug: slug_em('Community Support'),
    weight: 1
  )
  community_support_category.save
end

# Add indicators to each category

open_pr_indicator = CategoryIndicator.find_by(slug: slug_em('Pull Requests'))
if open_pr_indicator.nil?
  open_pr_indicator = CategoryIndicator.new(
    name: 'Pull Requests',
    slug: slug_em('Pull Requests'),
    indicator_type: 'scale',
    weight: 0.34,
    rubric_category_id: active_maintenance_category.id,
    data_source: 'GitHub',
    source_indicator: 'openPullRequestCount'
  )
  if open_pr_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: open_pr_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Ratio of open to merged pull requests.'
    indicator_desc.category_indicator_id = open_pr_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

open_issues_indicator = CategoryIndicator.find_by(slug: slug_em('Issues'))
if open_issues_indicator.nil?
  open_issues_indicator = CategoryIndicator.new(
    name: 'Issues',
    slug: slug_em('Issues'),
    indicator_type: 'scale',
    weight: 0.34,
    rubric_category_id: active_maintenance_category.id,
    data_source: 'GitHub',
    source_indicator: 'openIssues'
  )
  if open_issues_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: open_issues_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Ratio of opened to closed issues.'
    indicator_desc.category_indicator_id = open_issues_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

last_repo_activity_indicator = CategoryIndicator.find_by(slug: slug_em('Last Repository Activity'))
if last_repo_activity_indicator.nil?
  last_repo_activity_indicator = CategoryIndicator.new(
    name: 'Last Repository Activity',
    slug: slug_em('Last Repository Activity'),
    indicator_type: 'scale',
    weight: 0.34,
    rubric_category_id: active_maintenance_category.id,
    data_source: 'GitHub',
    source_indicator: 'updatedAt'
  )
  if last_repo_activity_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: last_repo_activity_indicator.id,
                                                          locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Last repository activity date.'
    indicator_desc.category_indicator_id = last_repo_activity_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

releases_indicator = CategoryIndicator.find_by(slug: slug_em('Releases'))
if releases_indicator.nil?
  releases_indicator = CategoryIndicator.new(
    name: 'Releases',
    slug: slug_em('Releases'),
    indicator_type: 'scale',
    weight: 0.15,
    rubric_category_id: software_usage_category.id,
    data_source: 'GitHub',
    source_indicator: 'releases'
  )
  if releases_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: releases_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of releases in the past year.'
    indicator_desc.category_indicator_id = releases_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

downloads_indicator = CategoryIndicator.find_by(slug: slug_em('Downloads'))
if downloads_indicator.nil?
  downloads_indicator = CategoryIndicator.new(
    name: 'Downloads',
    slug: slug_em('Downloads'),
    indicator_type: 'scale',
    weight: 0.1,
    rubric_category_id: software_usage_category.id,
    data_source: 'GitHub',
    source_indicator: 'downloadCount'
  )
  if downloads_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: downloads_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of times release assets have been downloaded.'
    indicator_desc.category_indicator_id = downloads_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

forks_indicator = CategoryIndicator.find_by(slug: slug_em('Forks'))
if forks_indicator.nil?
  forks_indicator = CategoryIndicator.new(
    name: 'Forks',
    slug: slug_em('Forks'),
    indicator_type: 'scale',
    weight: 0.25,
    rubric_category_id: software_usage_category.id,
    data_source: 'GitHub',
    source_indicator: 'forkCount'
  )
  if forks_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: forks_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of forks.'
    indicator_desc.category_indicator_id = forks_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

stars_indicator = CategoryIndicator.find_by(slug: slug_em('Stars'))
if stars_indicator.nil?
  stars_indicator = CategoryIndicator.new(
    name: 'Stars',
    slug: slug_em('Stars'),
    indicator_type: 'scale',
    weight: 0.25,
    rubric_category_id: software_usage_category.id,
    data_source: 'GitHub',
    source_indicator: 'stargazers'
  )
  if stars_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: stars_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of stars.'
    indicator_desc.category_indicator_id = stars_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

watchers_indicator = CategoryIndicator.find_by(slug: slug_em('Watchers'))
if watchers_indicator.nil?
  watchers_indicator = CategoryIndicator.new(
    name: 'Watchers',
    slug: slug_em('Watchers'),
    indicator_type: 'scale',
    weight: 0.25,
    rubric_category_id: software_usage_category.id,
    data_source: 'GitHub',
    source_indicator: 'watchers'
  )
  if watchers_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: watchers_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of watchers.'
    indicator_desc.category_indicator_id = watchers_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

commits_indicator = CategoryIndicator.find_by(slug: slug_em('Commits'))
if commits_indicator.nil?
  commits_indicator = CategoryIndicator.new(
    name: 'Commits',
    slug: slug_em('Commits'),
    indicator_type: 'scale',
    weight: 0.5,
    rubric_category_id: community_health_category.id,
    data_source: 'GitHub',
    source_indicator: 'commitsOnMasterBranch, commitsOnMainBranch'
  )
  if commits_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: commits_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of commits on master or main branch.'
    indicator_desc.category_indicator_id = commits_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

contributors_indicator = CategoryIndicator.find_by(slug: slug_em('Contributors'))
if contributors_indicator.nil?
  contributors_indicator = CategoryIndicator.new(
    name: 'Contributors',
    slug: slug_em('Contributors'),
    indicator_type: 'scale',
    weight: 0.5,
    rubric_category_id: community_health_category.id,
    data_source: 'GitHub',
    source_indicator: 'collaborators'
  )
  if contributors_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: contributors_indicator.id,
locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of contributors.'
    indicator_desc.category_indicator_id = contributors_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

language_indicator = CategoryIndicator.find_by(slug: slug_em('Language'))
if language_indicator.nil?
  language_indicator = CategoryIndicator.new(
    name: 'Language',
    slug: slug_em('Language'),
    indicator_type: 'scale',
    weight: 0.2,
    rubric_category_id: review_category.id,
    data_source: 'GitHub',
    source_indicator: 'language'
  )
  if language_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: language_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Language used in product is one of the Top 10 or Top 25 commonly used programming'\
                                 ' languages.'
    indicator_desc.category_indicator_id = language_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

documentation_indicator = CategoryIndicator.find_by(slug: slug_em('Documentation'))
if documentation_indicator.nil?
  documentation_indicator = CategoryIndicator.new(
    name: 'Documentation',
    slug: slug_em('Documentation'),
    indicator_type: 'scale',
    weight: 0.2,
    rubric_category_id: review_category.id,
    data_source: 'GitHub',
    source_indicator: 'documentation'
  )
  if documentation_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: documentation_indicator.id,
                                                          locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Code is documented with a README, CONTRIBUTING and/or link to documentation'\
                                 ' in the code repository.'
    indicator_desc.category_indicator_id = documentation_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

containerized_indicator = CategoryIndicator.find_by(slug: slug_em('Containerized'))
if containerized_indicator.nil?
  containerized_indicator = CategoryIndicator.new(
    name: 'Containerized',
    slug: slug_em('Containerized'),
    indicator_type: 'boolean',
    weight: 0.2,
    rubric_category_id: review_category.id,
    data_source: 'GitHub',
    source_indicator: 'containerized'
  )
  if containerized_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: containerized_indicator.id,
                                                          locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'The code contains a dockerfile, allowing the product to be deployed easily.'
    indicator_desc.category_indicator_id = containerized_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

license_indicator = CategoryIndicator.find_by(slug: slug_em('License'))
if license_indicator.nil?
  license_indicator = CategoryIndicator.new(
    name: 'License',
    slug: slug_em('License'),
    indicator_type: 'boolean',
    weight: 0.2,
    rubric_category_id: review_category.id,
    data_source: 'GitHub',
    source_indicator: 'license'
  )
  if license_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: license_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'The code contains a valid LICENSE file.'
    indicator_desc.category_indicator_id = license_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

api_docs_indicator = CategoryIndicator.find_by(slug: slug_em('API Documentation'))
if api_docs_indicator.nil?
  api_docs_indicator = CategoryIndicator.new(
    name: 'API Documentation',
    slug: slug_em('API Documentation'),
    indicator_type: 'boolean',
    weight: 0.2,
    rubric_category_id: review_category.id,
    data_source: 'GitHub',
    source_indicator: 'API Docs'
  )
  if api_docs_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: api_docs_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'The product has a documented API (Swagger/OpenAPI).'
    indicator_desc.category_indicator_id = api_docs_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

# rubocop:disable Layout/LineLength
developer_indicator = CategoryIndicator.find_by(slug: slug_em('Developer, Contributor and Implementor Community Engagement'))
if developer_indicator.nil?
  developer_indicator = CategoryIndicator.new(
    name: 'Developer, Contributor and Implementor Community Engagement',
    slug: slug_em('Developer, Contributor and Implementor Community Engagement'),
    indicator_type: 'boolean',
    weight: 0.2,
    rubric_category_id: community_support_category.id,
    data_source: 'Digital Square',
    source_indicator: 'Developer, Contributor and Implementor Community Engagement'
  )
  if developer_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: developer_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Developer, Contributor and Implementor Community Engagement'
    indicator_desc.category_indicator_id = developer_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

governance_indicator = CategoryIndicator.find_by(slug: slug_em('Community Governance'))
if governance_indicator.nil?
  governance_indicator = CategoryIndicator.new(
    name: 'Community Governance',
    slug: slug_em('Community Governance'),
    indicator_type: 'boolean',
    weight: 0.2,
    rubric_category_id: community_support_category.id,
    data_source: 'Digital Square',
    source_indicator: 'Community Governance'
  )
  if governance_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: governance_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Community Governance'
    indicator_desc.category_indicator_id = governance_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

roadmap_indicator = CategoryIndicator.find_by(slug: slug_em('Software Roadmap'))
if roadmap_indicator.nil?
  roadmap_indicator = CategoryIndicator.new(
    name: 'Software Roadmap',
    slug: slug_em('Software Roadmap'),
    indicator_type: 'boolean',
    weight: 0.2,
    rubric_category_id: community_support_category.id,
    data_source: 'Digital Square',
    source_indicator: 'Software Roadmap'
  )
  if roadmap_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: roadmap_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Software Roadmap'
    indicator_desc.category_indicator_id = roadmap_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

user_doc_indicator = CategoryIndicator.find_by(slug: slug_em('User Documentation'))
if user_doc_indicator.nil?
  user_doc_indicator = CategoryIndicator.new(
    name: 'User Documentation',
    slug: slug_em('User Documentation'),
    indicator_type: 'boolean',
    weight: 0.2,
    rubric_category_id: community_support_category.id,
    data_source: 'Digital Square',
    source_indicator: 'User Documentation'
  )
  if user_doc_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: user_doc_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'User Documentation'
    indicator_desc.category_indicator_id = user_doc_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

multi_lingual_indicator = CategoryIndicator.find_by(slug: slug_em('Multi-Lingual Support'))
if multi_lingual_indicator.nil?
  multi_lingual_indicator = CategoryIndicator.new(
    name: 'Multi-Lingual Support',
    slug: slug_em('Multi-Lingual Support'),
    indicator_type: 'boolean',
    weight: 0.2,
    rubric_category_id: community_support_category.id,
    data_source: 'Digital Square',
    source_indicator: 'Multi-Lingual Support'
  )
  if multi_lingual_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: multi_lingual_indicator.id,
locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Multi-Lingual Support'
    indicator_desc.category_indicator_id = multi_lingual_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end
