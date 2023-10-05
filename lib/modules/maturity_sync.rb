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

      maturity_score = {}

      product_indicators = ProductIndicator
                           .where('product_id = ?', product_id)
                           .map { |indicator| { indicator.category_indicator_id.to_s => indicator.indicator_value } }
                           .reduce({}, :merge)

      rubric_categories = RubricCategory.includes(:rubric_category_descriptions)

      rubric_missing_score = 0
      rubric_overall_score = 0
      rubric_maximum_score = 0
      rubric_indicator_count = 0
      rubric_category_scores = []
      rubric_categories.each do |rubric_category|
        category_indicators = CategoryIndicator.where(rubric_category:)
                                               .includes(:category_indicator_descriptions)
        category_missing_score = 0
        category_overall_score = 0
        category_maximum_score = 0
        category_indicator_scores = []
        category_indicators.each do |category_indicator|
          indicator_value = product_indicators[category_indicator.id.to_s]
          indicator_type = category_indicator.indicator_type
          indicator_description = category_indicator.category_indicator_descriptions.first

          description = indicator_description&.description&.gsub(/<\/?[^>]*>/, '')
          score = convert_score_scale(indicator_value, indicator_type, category_indicator.weight)
          if score == 'N/A'
            category_missing_score += 1
          else
            category_overall_score += score
            category_maximum_score += category_indicator.weight * 10
          end

          category_indicator_scores << {
            'id' => category_indicator.id,
            'name' => category_indicator.name,
            'weight' => category_indicator.weight,
            'description' => description,
            'score' => score
          }
        end

        # Occasionally, rounding errors can lead to a score > 10
        category_overall_score = 10.0 if category_overall_score > 10

        # Update rubric level data
        rubric_overall_score += category_overall_score
        rubric_maximum_score += category_maximum_score

        # Update other metadata about the maturity
        rubric_missing_score += category_missing_score
        rubric_indicator_count += category_indicator_scores.count

        category_description = rubric_category.rubric_category_descriptions.first
        rubric_category_scores << {
          'id' => rubric_category.id,
          'name' => rubric_category.name,
          'weight' => rubric_category.weight,
          'description' => category_description&.description&.gsub(/<\/?[^>]*>/, ''),
          'overallScore' => category_overall_score,
          'maximumScore' => category_maximum_score,
          'missingScore' => category_missing_score,
          'categoryIndicators' => category_indicator_scores
        }

        maturity_score['rubricCategories'] = rubric_category_scores
      end

      # Now do final score calculation
      valid_category_count = 0
      overall_category_score = 0
      maturity_score['rubricCategories'].each do |category|
        if category['overallScore'].positive?
          valid_category_count += 1
          overall_category_score += category['overallScore'].to_f / category['maximumScore'].to_f
        end
      end

      if valid_category_count.positive?
        overall_maturity_score = overall_category_score.to_f / valid_category_count * 100
      end

      maturity_score['totalScore'] = rubric_overall_score&.round(2)
      maturity_score['maximumScore'] = rubric_maximum_score&.round(2)
      maturity_score['overallScore'] = overall_maturity_score&.round(2)

      # Other metadata for the rubric calculation.
      maturity_score['missingScore'] = rubric_missing_score
      maturity_score['indicatorCount'] = rubric_indicator_count

      # Change to info to output data to console.
      logger.debug("Maturity data: #{maturity_score.inspect}.")

      product = Product.find_by(id: product_id)
      product.maturity_score = JSON.parse(maturity_score.to_json)
      product.save!
    end

    def convert_score_scale(score, type, weight)
      return 'N/A' if score.nil? || score == 'N/A'

      numeric_value = 0

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

      # Get the number of collaborators and append
      collaborator_count = get_collaborator_count(product_repository)
      product_repository.statistical_data["collaborators"] = collaborator_count

      puts "Repository statistical data for #{product_repository.name} saved." if product_repository.save!
    end

    def graph_ql_statistics(owner, repo)
      <<~STATISTIC_GQL
        {
          repository(name: "#{repo}", owner: "#{owner}") {
            commitsOnMasterBranch: object(expression: "master") {
              ... on Commit {
                history {
                  totalCount
                }
              }
            }
            commitsOnMainBranch: object(expression: "main") {
              ... on Commit {
                history {
                  totalCount
                }
              }
            }
            stargazers {
              totalCount
            },
            watchers {
              totalCount
            },
            forkCount,
            isFork,
            createdAt,
            updatedAt,
            pushedAt,
            closedPullRequestCount: pullRequests(states: CLOSED) {
              totalCount
            },
            openPullRequestCount: pullRequests(states: OPEN) {
              totalCount
            },
            mergedPullRequestCount: pullRequests(states: MERGED) {
              totalCount
            },
            closedIssues: issues(states: CLOSED) {
              totalCount
            },
            openIssues: issues(states: OPEN) {
              totalCount
            },
            releases(last: 1) {
              totalCount,
              edges {
                node {
                  name,
                  tagName,
                  createdAt,
                  description,
                  url,
                  releaseAssets(last: 1) {
                    edges {
                      node {
                        downloadCount
                      }
                    }
                  }
                }
              }
            }
          }
        }
      STATISTIC_GQL
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

    def sync_documentation_indicator(product)
      product_repositories = ProductRepository.where(product_id: product.id)

      indicator = CategoryIndicator.find_by(slug: 'documentation')
      product_indicator = ProductIndicator.find_by(product_id: product.id, category_indicator_id: indicator.id)
      if product_indicator.nil?
        product_indicator = ProductIndicator.new(product_id: product.id,
                                                 category_indicator_id: indicator.id,
                                                 indicator_value: 'low')
      end

      product_repositories.each do |repository|
        file_list = read_repository_file_list(repository)

        # github allows multiple file extensions of the readme file, this regex may be incomplete
        readme_regex =
          /^readme\.(?:markdown|mdown|mkdn|md|textile|rdoc|org|creole|mediawiki|wiki|rst|asciidoc|adoc|asc|pod|txt)/i

        readme_file_name = 'Readme.md'
        unless file_list.nil? || file_list["data"]["repository"].nil?
          file_list["data"]["repository"]["object"]["entries"].each do |current_file|
            if current_file["name"].match(readme_regex)
              readme_file_name = current_file["name"]
            end
          end
        end

        contributing_regex = %r/^contributing\.(?:markdown|mdown|mkdn|md|textile|rdoc|org|creole|mediawiki|wiki|rst
                                |asciidoc|adoc|asc|pod|txt)/i

        contributing_file_name = 'Contributing.md'
        unless file_list.nil? || file_list["data"]["repository"].nil?
          file_list["data"]["repository"]["object"]["entries"].each do |current_file|
            if current_file["name"].match(contributing_regex)
              contributing_file_name = current_file["name"]
            end
          end
        end

        # check for external documentation
        homepage_link_present = false
        readme_commit_count = 0
        contribution_file_present = false

        if get_homepage_url(repository)
          homepage_link_present = true
        end

        if check_file(file_list, contributing_file_name)
          contribution_file_present = true
        end

        if check_file(file_list, readme_file_name)
          readme_commit_count = get_commits_number_file(repository, readme_file_name)
        end

        if (readme_commit_count > 1 && contribution_file_present == true) ||
          (readme_commit_count > 1 && homepage_link_present == true)
          product_indicator.indicator_value = 'high'
        elsif readme_commit_count > 1 || homepage_link_present == true
          product_indicator.indicator_value = 'medium'
        else
          product_indicator.indicator_value = 'low'
        end
      end
      product_indicator.save!
    end

    def get_commits_number_file(repository, filepath)
      return 0 if repository.absolute_url.blank?
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = repository.absolute_url.match(repo_regex))

      _, owner, repo = match.captures

      github_uri = URI.parse("https://api.github.com/repos/#{owner}/#{repo}/commits?path=#{filepath}")
      http = Net::HTTP.new(github_uri.host, github_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(github_uri)
      if ENV['GITHUB_USERNAME'].nil? || ENV['GITHUB_PERSONAL_TOKEN'].nil?
        raise NoGithubCredentialsException
      end
      request.basic_auth(ENV['GITHUB_USERNAME'], ENV['GITHUB_PERSONAL_TOKEN'])

      response = http.request(request)
      json_response = JSON.parse(response.body)
      json_response.size
    end

    def get_collaborator_count(repository)
      return 0 if repository.absolute_url.blank?
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = repository.absolute_url.match(repo_regex))

      _, owner, repo = match.captures

      github_uri = URI.parse("https://api.github.com/repos/#{owner}/#{repo}/contributors?per_page=1&anon=true")
      http = Net::HTTP.new(github_uri.host, github_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(github_uri)
      if ENV['GITHUB_USERNAME'].nil? || ENV['GITHUB_PERSONAL_TOKEN'].nil?
        raise NoGithubCredentialsException
      end
      request.basic_auth(ENV['GITHUB_USERNAME'], ENV['GITHUB_PERSONAL_TOKEN'])

      response = http.request(request)

      return 0 if response['Link'].nil?

      link_header = response['Link'].split(',')[1]
      collaborator_count = link_header.partition("&page=").last
      collaborator_count.partition(">;").first
    end

    def get_homepage_url(repository)
      return 0 if repository.absolute_url.blank?
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = repository.absolute_url.match(repo_regex))

      _, owner, repo = match.captures

      github_uri = URI.parse("https://api.github.com/repos/#{owner}/#{repo}")
      http = Net::HTTP.new(github_uri.host, github_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(github_uri)
      if ENV['GITHUB_USERNAME'].nil? || ENV['GITHUB_PERSONAL_TOKEN'].nil?
        raise NoGithubCredentialsException
      end
      request.basic_auth(ENV['GITHUB_USERNAME'], ENV['GITHUB_PERSONAL_TOKEN'])

      response = http.request(request)
      json_response = JSON.parse(response.body)
      json_response["homepage"]
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

      if product_repository.save!
        puts "Repository language data for '#{product_repository.name}' saved."
      end
    end

    def graph_ql_languages(owner, repo)
      <<~LANGUAGE_GQL
        {
          repository(name: "#{repo}", owner: "#{owner}") {
            languages(first: 20, orderBy: {field: SIZE, direction: DESC}) {
              totalCount
              totalSize
              edges {
                size
                node {
                  name
                  color
                }
              }
            }
          }
        }
      LANGUAGE_GQL
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
        docker_compose = check_file(file_list, 'docker-compose.yml')

        if dockerfile == true || docker_compose == true
          product_indicator.indicator_value = 't'
          break
        end
      end
      product_indicator.save!
    end

    def sync_license_indicator(product)
      product_repositories = ProductRepository.where(product_id: product.id)

      indicator = CategoryIndicator.find_by(slug: 'license')
      product_indicator = ProductIndicator.find_by(product_id: product.id, category_indicator_id: indicator.id)
      if product_indicator.nil?
        product_indicator = ProductIndicator.new(product_id: product.id,
                                                 category_indicator_id: indicator.id,
                                                 indicator_value: 'f')
      end

      product_repositories.each do |repository|
        file_list = read_repository_file_list(repository)
        license_file = check_file(file_list, 'LICENSE')
        unless license_file
          license_file = check_file(file_list, 'LICENSE.md')
        end

        if license_file == true
          product_indicator.indicator_value = 't'
          break
        end
      end
      product_indicator.save!
    end

    def check_file(file_list, file_name)
      unless file_list.nil? || file_list["data"].nil? || file_list["data"]["repository"].nil?
        file_list = file_list["data"]["repository"]["object"]["entries"]

        file_list.each do |file|
          if file["name"] == file_name
            return true
          end
        end
      end
      false
    end

    class NoGithubCredentialsException < StandardError
      def initialize(msg = "No github credentials provided.", exception_type = "custom")
        @exception_type = exception_type
        super(msg)
      end
    end

    def read_repository_file_list(repository)
      return nil if repository.absolute_url.blank?
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = repository.absolute_url.match(repo_regex))

      _, owner, repo = match.captures

      if repo[-1] == '/'
        repo.slice!('/')
      end

      github_uri = URI.parse('https://api.github.com/graphql')
      http = Net::HTTP.new(github_uri.host, github_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(github_uri.path)
      if ENV['GITHUB_USERNAME'].nil? || ENV['GITHUB_PERSONAL_TOKEN'].nil?
        raise NoGithubCredentialsException
      end
      request.basic_auth(ENV['GITHUB_USERNAME'], ENV['GITHUB_PERSONAL_TOKEN'])
      request.body = { 'query' => graph_ql_file_list(owner, repo) }.to_json

      response = http.request(request)
      JSON.parse(response.body)
    end

    def graph_ql_file_list(owner, repo)
      <<~FILE_LIST_GQL
        {
          repository(name: "#{repo}", owner: "#{owner}") {
            object(expression: "HEAD:") {
              ... on Tree {
                entries {
                  name
                }
              }
            }
          }
        }
      FILE_LIST_GQL
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
      <<~FILE_CONTENT_GQL
        {
          repository(name: "#{repo}", owner: "#{owner}") {
            object(expression: "master:src/data/") {
              ... on Tree {
                entries {
                  object {
                    ...on Blob {
                      text
                    }
                  }
                }
              }
            }
          }
        }
      FILE_CONTENT_GQL
    end

    def sum_languages(product_languages)
      languages = product_languages.dup.uniq! { |lang| lang["node"] }
      languages = product_languages if languages.nil?
      total_product_languages = []
      languages&.each do |language|
        certain_lang = product_languages.select { |lang| lang["node"]["name"] == language["node"]["name"] }
        counter = 0
        certain_lang.each do |lang|
          counter += lang["size"]
        end
        total_product_languages.push({ "node" => { "name" => certain_lang[0]["node"]["name"],
                                                   "color" => certain_lang[0]["node"]["color"] },
                                       "size" => counter })
      end
      total_product_languages.flatten.sort_by { |k| -k["size"] }
    end

    def read_indicator_config(indicator_config, category_name, indicator_name)
      indicator_config.each do |category|
        next if category['category'] != category_name

        category['indicators'].each do |indicator|
          next if indicator['name'] != indicator_name

          low_calculations = []
          indicator['low'].each do |calculation|
            low_calculations << { 'operator': calculation['operator'], 'value': calculation['value'] }
          end

          medium_calculations = []
          indicator['medium'].each do |calculation|
            medium_calculations << { 'operator': calculation['operator'], 'value': calculation['value'] }
          end

          high_calculations = []
          indicator['high'].each do |calculation|
            high_calculations << { 'operator': calculation['operator'], 'value': calculation['value'] }
          end

          return {
            'name': indicator['name'],
            'low': low_calculations,
            'medium': medium_calculations,
            'high': high_calculations
          }
        end
      end

      { 'error': 'Indicator not found' }
    end

    def calculate_product_indicators(product_id)
      product_repositories = ProductRepository.where(product_id:)
      github_category_indicators = CategoryIndicator.where(data_source: 'GitHub')

      config_file = YAML.load_file('config/indicator_config.yml')

      github_category_indicators.each do |indicator|
        product_indicator = ProductIndicator.find_by(product_id:, category_indicator_id: indicator.id)
        if product_indicator.nil?
          product_indicator = ProductIndicator.new(product_id:, category_indicator_id: indicator.id)
        end

        statistical_data = calculate_total_repo_statistical_data(indicator, product_repositories)

        indicator_scales = [:low, :medium, :high]

        statistical_data.each do |statistical_data_pair|
          indicator_name, statistical_value = statistical_data_pair
          if statistical_value == 'N/A'
            product_indicator.indicator_value = 'N/A'
            product_indicator.save
            puts "Setting N/A for #{indicator_name}."
            next
          end

          indicator_scales.each do |indicator_scale|
            indicator_value = calculate_indicator_value(config_file, indicator, statistical_value, indicator_scale)
            unless indicator_value.nil?
              product_indicator.indicator_value = indicator_value
              product_indicator.save
            end
          end
        end
      end
    end

    def calculate_total_repo_statistical_data(indicator, product_repositories)
      total_repo_statistical_data = Hash.new(0)
      counter = 0
      ratio_counter = 0
      update_date = "1950-01-10T00:00:01Z"

      product_repositories.each do |repo|
        next if repo.statistical_data == {} || repo.statistical_data.class == String ||
                repo.statistical_data["data"].nil? || repo.statistical_data["data"]["repository"].nil?

        if indicator.source_indicator.in?(["releases", "stargazers", "watchers"])
          unless repo.statistical_data["data"]["repository"][indicator.source_indicator].nil?
            counter += repo.statistical_data["data"]["repository"][indicator.source_indicator]["totalCount"]
          end
          total_repo_statistical_data[indicator.name] = counter

        elsif indicator.source_indicator.in?(["openIssues", "openPullRequestCount"])
          if indicator.source_indicator == "openIssues"
            closed_indicator = "closedIssues"
          else
            closed_indicator = "closedPullRequestCount"
          end
          unless repo.statistical_data["data"]["repository"][indicator.source_indicator].nil? ||
            repo.statistical_data["data"]["repository"][indicator.source_indicator] == 0
            counter += repo.statistical_data["data"]["repository"][indicator.source_indicator]["totalCount"]
            ratio_counter += repo.statistical_data["data"]["repository"][closed_indicator]["totalCount"]
          end

        elsif indicator.source_indicator.in?(["downloadCount"])
          download_data = repo.statistical_data["data"]["repository"]["releases"]["edges"][0]
          unless download_data.nil?
            # rubocop:disable Layout/LineLength
            download_data = repo.statistical_data["data"]["repository"]["releases"]["edges"][0]["node"]["releaseAssets"]["edges"][0]
            unless download_data.nil?
              counter += repo.statistical_data["data"]["repository"]["releases"]["edges"][0]["node"]["releaseAssets"]["edges"][0]["node"][indicator.source_indicator]
              # rubocop:enable Layout/LineLength
            end
          end
          total_repo_statistical_data[indicator.source_indicator] = counter

        elsif indicator.source_indicator.in?(["commitsOnMasterBranch, commitsOnMainBranch"])
          unless repo.statistical_data["data"]["repository"]["commitsOnMasterBranch"].nil?
            counter += repo.statistical_data["data"]["repository"]["commitsOnMasterBranch"]["history"]["totalCount"]
          end
          unless repo.statistical_data["data"]["repository"]["commitsOnMainBranch"].nil?
            counter += repo.statistical_data["data"]["repository"]["commitsOnMainBranch"]["history"]["totalCount"]
          end
          total_repo_statistical_data[indicator.name] = counter

        elsif indicator.source_indicator.in?(["updatedAt"])
          if repo.statistical_data["data"]["repository"][indicator.source_indicator] > update_date
            update_date = repo.statistical_data["data"]["repository"][indicator.source_indicator]
          end
          total_repo_statistical_data[indicator.name] = (Date.today - update_date.to_date).to_i

        elsif indicator.source_indicator.in?(["forkCount"])
          counter += repo.statistical_data["data"]["repository"][indicator.source_indicator]
          total_repo_statistical_data[indicator.name] = counter

        elsif indicator.source_indicator.in?(["collaborators"])
          counter += repo.statistical_data["collaborators"].to_i unless repo.statistical_data["collaborators"].nil?
          total_repo_statistical_data[indicator.name] = counter

        elsif indicator.source_indicator.in?(["cloneCount"])
          counter += repo.statistical_data["collaborators"].to_i unless repo.statistical_data["collaborators"].nil?
          total_repo_statistical_data[indicator.name] = counter
        end
      end
      if indicator.source_indicator.in?(["openIssues", "openPullRequestCount"])
        if ratio_counter == 0
          total_repo_statistical_data[indicator.name] = 'N/A'
        else
          total_repo_statistical_data[indicator.name] = counter.to_f / ratio_counter.to_f
        end
      end
      total_repo_statistical_data
    end

    def calculate_indicator_value(config_file, indicator, statistical_value, indicator_scale)
      indicator_category = RubricCategory.find(indicator.rubric_category_id)
      indicator_config = read_indicator_config(config_file, indicator_category.name, indicator.name)

      indicator_scale_weight = 1
      condition_counter = 0..(indicator_config[indicator_scale].count - 1)
      condition_counter.each do |counter|
        if indicator_config[indicator_scale][counter][:operator].to_s == "equalTo"
          if statistical_value != indicator_config[indicator_scale][counter][:value]
            indicator_scale_weight *= 0
          end
        elsif indicator_config[indicator_scale][counter][:operator].to_s == "greaterThan"
          if statistical_value < indicator_config[indicator_scale][counter][:value]
            indicator_scale_weight *= 0
          end
        elsif indicator_config[indicator_scale][counter][:operator].to_s == "lessThan"
          if statistical_value > indicator_config[indicator_scale][counter][:value]
            indicator_scale_weight *= 0
          end
        end
      end
      indicator_scale.to_s if indicator_scale_weight == 1
    end

    def api_check(repository)
      return nil if repository.absolute_url.blank?
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = repository.absolute_url.match(repo_regex))

      indicator = CategoryIndicator.find_by(slug: 'api_documentation')

      product_indicator = ProductIndicator.find_by(product_id: repository.product_id,
                                                  category_indicator_id: indicator.id)
      if product_indicator.nil?
        product_indicator = ProductIndicator.new(product_id: repository.product_id,
                                                 category_indicator_id: indicator.id,
                                                 indicator_value: 'f')
      end

      _, owner, repo = match.captures

      queries = ['q=openapi+in:file+repo', 'q=swagger+in:file+repo']

      queries.each do |query|
        result = search_repo_code(owner, repo, query)
        unless result.nil?
          product_indicator.indicator_value = 't'
        end
      end
      product_indicator.save!
    end

    def search_repo_code(owner, repo, query)
      github_uri = URI.parse("https://api.github.com/search/code?#{query}:#{owner}/#{repo}")
      http = Net::HTTP.new(github_uri.host, github_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(github_uri)
      request.basic_auth(ENV['GITHUB_USERNAME'], ENV['GITHUB_PERSONAL_TOKEN'])

      response = JSON.parse(http.request(request).body)
      response["total_count"] if response["total_count"] && response["total_count"] != 0
    end

    def sync_language_indicator(config_file, lang_file, product)
      indicator = CategoryIndicator.find_by(slug: 'language')

      product_indicator = ProductIndicator.find_by(product_id: product.id, category_indicator_id: indicator.id)
      if product_indicator.nil?
        product_indicator = ProductIndicator.new(product_id: product.id, category_indicator_id: indicator.id,
                                                 indicator_value: 'low')
      end

      product_top_languages = product.languages
      return if product_top_languages.nil?

      product_indicator.indicator_value = 'low'
      indicator_scales = [:low, :medium, :high]
      lang_file.each do |lang|
        next if product_top_languages[0]["node"]["name"] != lang["name"]
        language_value = lang["rank"]
        indicator_scales.each do |indicator_scale|
          current_indicator_scale = calculate_indicator_value(config_file, indicator, language_value, indicator_scale)
          next if current_indicator_scale.nil?

          product_indicator.indicator_value = current_indicator_scale
        end
      end
      product_indicator.save!
    end
  end
end
