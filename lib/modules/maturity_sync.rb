# frozen_string_literal: true

module Modules
  module MaturitySync
    def create_category(cat_name)
      category_slug = slug_em(cat_name)
      rubric_category = RubricCategory.where(slug: category_slug)
                                      .first || RubricCategory.new
      rubric_category.name = cat_name
      rubric_category.slug = category_slug
      rubric_category.weight = 1.0
      rubric_category.save!

      rubric_category_desc = RubricCategoryDescription.where(rubric_category_id: rubric_category.id,
                                                             locale: I18n.locale)
                                                      .first || RubricCategoryDescription.new
      rubric_category_desc.rubric_category_id = rubric_category.id
      rubric_category_desc.locale = I18n.locale
      rubric_category_desc.description = "<p>#{cat_name}</p>"
      rubric_category_desc.save

      rubric_category
    end

    def create_indicator(indicator_name, indicator_desc, indicator_source, indicator_count, indicator_type, category_id)
      indicator_slug = slug_em(indicator_name)
      category_indicator = CategoryIndicator.where(rubric_category_id: category_id, slug: indicator_slug)
                                            .first || CategoryIndicator.new
      category_indicator.name = indicator_name
      category_indicator.slug = indicator_slug
      category_indicator.rubric_category_id = category_id
      category_indicator.data_source = indicator_source
      category_indicator.weight = (1000.0 / indicator_count.to_f).round / 1000.0
      category_indicator.source_indicator = indicator_name
      category_indicator.indicator_type = CategoryIndicator.category_indicator_types.key(indicator_type.downcase)
      category_indicator.save!

      category_indicator_desc = CategoryIndicatorDescription.where(category_indicator_id: category_indicator.id,
                                                                   locale: I18n.locale)
                                                            .first || CategoryIndicatorDescription.new
      category_indicator_desc.category_indicator_id = category_indicator.id
      category_indicator_desc.locale = I18n.locale
      category_indicator_desc.description = "<p>#{indicator_desc}</p>"
      category_indicator_desc.save
    end

    def calculate_maturity_scores(product_id)
      logger = Logger.new($stdout)
      logger.level = Logger::INFO

      product_indicators = ProductIndicator
                           .where('product_id = ?', product_id)
                           .map { |indicator| { indicator.category_indicator_id.to_s => indicator.indicator_value } }

      product_indicators = product_indicators.reduce({}, :merge)

      product_score = { rubric_scores: [] }

      rubric_score = {
        category_scores: [],
        indicator_count: 0,
        # Number of indicator without score at the rubric level.
        missing_score: 0,
        # Overall score at the rubric level
        overall_score: 0
      }

      rubric_categories = RubricCategory.all.includes(:rubric_category_descriptions)
      rubric_categories.each do |rubric_category|
        category_description = rubric_category.rubric_category_descriptions.first
        category_score = {
          id: rubric_category.id,
          name: rubric_category.name,
          weight: rubric_category.weight,
          description: !category_description.nil? && !category_description.description.nil? &&
                        category_description.description.gsub(/<\/?[^>]*>/, ''),
          indicator_scores: [],
          # Number of indicator without score at the category level.
          missing_score: 0,
          # Overall score at the category level
          overall_score: 0
        }
        category_indicators = CategoryIndicator.where(rubric_category: rubric_category)
                                               .includes(:category_indicator_descriptions)
        category_indicators.each do |category_indicator|
          indicator_value = product_indicators[category_indicator.id.to_s]
          indicator_type = category_indicator.indicator_type
          indicator_description = category_indicator.category_indicator_descriptions.first

          indicator_score = {
            id: category_indicator.id,
            name: category_indicator.name,
            weight: category_indicator.weight,
            description: !indicator_description.nil? && indicator_description.description.gsub(/<\/?[^>]*>/, ''),
            score: convert_to_numeric(indicator_value, indicator_type, category_indicator.weight)
          }

          if indicator_score[:score].nil?
            category_score[:missing_score] += 1
          else
            category_score[:overall_score] += indicator_score[:score]
          end
          category_score[:indicator_scores] << indicator_score
        end

        # Occasionally, rounding errors can lead to a score > 10
        category_score[:overall_score] = 10.0 if category_score[:overall_score] > 10
        rubric_score[:indicator_count] += category_score[:indicator_scores].count
        rubric_score[:missing_score] += category_score[:missing_score]
        rubric_score[:overall_score] += category_score[:overall_score]
        rubric_score[:category_scores] << category_score
      end

      # Now do final score calculation
      total_categories = 0
      rubric_score[:category_scores].each do |category|
        total_categories += 1 if (category[:overall_score]).positive?
      end
      if total_categories.positive?
        rubric_score[:overall_score] =
          rubric_score[:overall_score] * 10 / total_categories
      end
      product_score[:rubric_scores] << rubric_score

      logger.debug("Rubric score for product: #{product_id} is: #{product_score.to_json}")
      product_score
    end

    def convert_to_numeric(score, type, weight)
      numeric_value = 0
      return numeric_value if score.nil?

      case type
      when 'boolean'
        numeric_value = 10.0 * weight if %w[true t].include?(score)
      when 'scale'
        case score
        when 'medium'
          numeric_value = 5.0 * weight
        when 'high'
          numeric_value = 10.0 * weight
        end
      when 'numeric'
        numeric_value = score.to_f * weight
      end
      numeric_value
    end

    def sync_product_statistics(product_repository)
      return if product_repository.absolute_url.blank?

      puts "Processing: #{product_repository.absolute_url}"
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = product_repository.absolute_url.match(repo_regex))

      _, owner, repo = match.captures

      github_uri = URI.parse('https://api.github.com/graphql')
      http = Net::HTTP.new(github_uri.host, github_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(github_uri.path)
      request.basic_auth(ENV['GITHUB_USERNAME'], ENV['GITHUB_PERSONAL_TOKEN'])
      request.body = { 'query' => graph_ql_statistics(owner, repo) }.to_json

      response = http.request(request)
      product_repository.statistical_data = JSON.parse(response.body)

      puts "Repository statistical data for #{product_repository.name} saved." if product_repository.save!
    end

    def graph_ql_statistics(owner, repo)
      '{'\
      '  repository(name: "' + repo + '", owner: "' + owner + '") {'\
      '    commitsOnMasterBranch: object(expression: "master") {'\
      '      ... on Commit {'\
      '        history {'\
      '           totalCount'\
      '        }'\
      '      }'\
      '    }'\
      '    commitsOnMainBranch: object(expression: "main") {'\
      '      ... on Commit {'\
      '        history {'\
      '           totalCount'\
      '        }'\
      '      }'\
      '    }'\
      '    stargazers {'\
      '      totalCount'\
      '    },'\
      '    watchers {'\
      '      totalCount'\
      '    },'\
      '    forkCount,'\
      '    isFork,'\
      '    createdAt,'\
      '    updatedAt,'\
      '    pushedAt,'\
      '    closedPullRequestCount: pullRequests(states: CLOSED) {'\
      '      totalCount'\
      '    },'\
      '    openPullRequestCount: pullRequests(states: OPEN) {'\
      '      totalCount'\
      '    },'\
      '    mergedPullRequestCount: pullRequests(states: MERGED) {'\
      '      totalCount'\
      '    },'\
      '    closedIssues: issues(states: CLOSED) {'\
      '      totalCount'\
      '    },'\
      '    openIssues: issues(states: OPEN) {'\
      '      totalCount'\
      '    },'\
      '    releases(last: 1) {'\
      '      totalCount,'\
      '      edges {'\
      '        node {'\
      '          name,'\
      '          createdAt,'\
      '          description,'\
      '          url,'\
      '          releaseAssets (last: 1) {'\
      '            edges {'\
      '              node {'\
      '                downloadCount'\
      '              }'\
      '            }'\
      '          }'\
      '        }'\
      '      }'\
      '    }'\
      '  }'\
      '}'\
    end

    def sync_license_information(product_repository)
      return if product_repository.absolute_url.blank?

      puts "Processing: #{product_repository.absolute_url}"
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = product_repository.absolute_url.match(repo_regex))

      _, owner, repo = match.captures

      command = "OCTOKIT_ACCESS_TOKEN=#{ENV['GITHUB_PERSONAL_TOKEN']} licensee detect --remote #{owner}/#{repo}"
      stdout, = Open3.capture3(command)

      return if stdout.blank?

      license_data = stdout
      license = stdout.lines.first.split(/\s+/)[1]

      if license != 'NOASSERTION'
        product_repository.license_data = license_data
        product_repository.license = license

        puts "Repository license data for #{product_repository.name} saved." if product_repository.save!
      end
    end

    def sync_product_languages(product_repository)
      return if product_repository.absolute_url.blank?

      puts "Processing: #{product_repository.absolute_url}"
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = product_repository.absolute_url.match(repo_regex))

      _, owner, repo = match.captures

      github_uri = URI.parse('https://api.github.com/graphql')
      http = Net::HTTP.new(github_uri.host, github_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(github_uri.path)
      request.basic_auth(ENV['GITHUB_USERNAME'], ENV['GITHUB_PERSONAL_TOKEN'])
      request.body = { 'query' => graph_ql_languages(owner, repo) }.to_json

      response = http.request(request)
      product_repository.language_data = JSON.parse(response.body)

      puts "Repository language data for '#{product_repository.name}' saved." if product_repository.save!
    end

    def graph_ql_languages(owner, repo)
      '{'\
      '  repository(name: "' + repo + '", owner: "' + owner + '") {'\
      '    languages(first: 20, orderBy: {field: SIZE, direction: DESC}) {'\
      '      totalCount'\
      '      totalSize'\
      '      edges {'\
      '        size'\
      '        node {'\
      '          name'\
      '          color'\
      '        }'\
      '      }'\
      '    }'\
      '  }'\
      '}'\
    end

    def sync_containerized_indicator(product)
      product_repositories = ProductRepository.where(product_id: product.id)

      indicator = CategoryIndicator.find_by(slug: 'containerized')
      product_indicator = ProductIndicator.find_by(product_id: product.id, category_indicator_id: indicator.id)
      if product_indicator.nil?
        product_indicator = ProductIndicator.new(product_id: product.id,
                                                 category_indicator_id: indicator.id,
                                                 indicator_value: 'f')
      end

      product_repositories.each do |repository|
        file_list = read_repository_file_list(repository)
        dockerfile = check_file(file_list, 'Dockerfile')

        if dockerfile == true
          product_indicator.indicator_value = 't'
          break
        end
      end
      product_indicator.save!
    end

    def check_file(file_list, file_name)
      unless file_list.nil? || file_list["data"]["repository"].nil?
        file_list = file_list["data"]["repository"]["object"]["entries"]

        file_list.each do |file|
          if file["name"] == file_name
            return true
          end
        end
      end
    end

    def read_repository_file_list(repository)
      return nil if repository.absolute_url.blank?
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = repository.absolute_url.match(repo_regex))

      _, owner, repo = match.captures

      github_uri = URI.parse('https://api.github.com/graphql')
      http = Net::HTTP.new(github_uri.host, github_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(github_uri.path)
      request.basic_auth(ENV['GITHUB_USERNAME'], ENV['GITHUB_PERSONAL_TOKEN'])
      request.body = { 'query' => graph_ql_file_list(owner, repo) }.to_json

      response = http.request(request)
      JSON.parse(response.body)
    end

    def graph_ql_file_list(owner, repo)
      '{'\
      '  repository(name: "' + repo + '", owner: "' + owner + '") {'\
      '    object(expression: "HEAD:") {'\
      '      ... on Tree {'\
      '        entries {'\
      '          name'\
      '        }'\
      '      }'\
      '    }'\
      '  }'\
      '}'\
    end

    def read_languages_file
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      absolute_url = 'https://github.com/madnight/githut'
      return unless (match = absolute_url.match(repo_regex))

      _, owner, repo = match.captures

      github_uri = URI.parse('https://api.github.com/graphql')
      http = Net::HTTP.new(github_uri.host, github_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(github_uri.path)
      request.basic_auth(ENV['GITHUB_USERNAME'], ENV['GITHUB_PERSONAL_TOKEN'])
      request.body = { 'query' => graph_ql_file_contents(owner, repo) }.to_json

      response = JSON.parse(http.request(request).body)
      languages_list = JSON.parse(response["data"]["repository"]["object"]["entries"][0]["object"]["text"])

      year = languages_list[-1]["year"]
      quarter = languages_list[-1]["quarter"]

      fresh_language_data = []

      languages_list.each do |language|
        language["count"] = language["count"].to_i
        fresh_language_data << language if language["year"] == year && language["quarter"] == quarter
      end

      top_25_languages = fresh_language_data.sort_by { |k| -k["count"] }[0..24]

      rank = 1
      top_25_languages.each do |language|
        ["year", "quarter", "count"].each { |k| language.delete(k) }
        language["rank"] = rank
        rank += 1
      end

      File.open("utils/top_25_languages.yml", "w") do |f|
        f.write(top_25_languages.to_yaml)
      end

      puts "Repository language data for TOP 25 saved."
    end

    def graph_ql_file_contents(owner, repo)
      '{'\
      '  repository(name: "' + repo + '", owner: "' + owner + '") {'\
      '    object(expression: "master:src/data/") {'\
      '      ... on Tree {'\
      '        entries {'\
      '          object {'\
      '          ... on Blob {'\
      '            text'\
      '           }'\
      '          }'\
      '        }'\
      '      }'\
      '    }'\
      '  }'\
      '}'\
    end
  end
end
