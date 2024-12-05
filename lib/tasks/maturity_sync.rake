# frozen_string_literal: true

require 'modules/maturity_sync'
require 'modules/slugger'
require 'modules/track'
require 'kramdown'
require 'nokogiri'

include Modules::MaturitySync
include Modules::Slugger
include Modules::Track
include Kramdown
include Nokogiri

namespace :maturity_sync do
  task :sync_data, [:path] => :environment do |_, params|
    logger = Logger.new($stdout)
    logger.level = Logger::DEBUG

    Dir.glob("#{params[:path]}/categories/*.md").each do |category_page|
      next if category_page.include?('sources')

      data = File.read(category_page)
      html_md = Kramdown::Document.new(data).to_html
      html_fragment = Nokogiri::HTML.fragment(html_md)

      document_header = html_fragment.at_css('h1')
      logger.debug("Category Header: #{document_header.inner_html}")

      category_name = document_header.inner_html
      category_slug = reslug_em(category_name)

      duplicate_categories = RubricCategory.where(slug: category_slug)
                                           .order(slug: :desc)

      rubric_category = nil
      if duplicate_categories.count.positive?
        first_duplicate = duplicate_categories.first
        # It's a duplicate because it's belong to a separate rubric.
        # Calculate the offset.
        dupe = RubricCategory.slug_starts_with(category_slug)
                             .order(slug: :desc)
                             .first
        size = 1
        unless dupe.nil?
          size = dupe.slug
                     .slice(/_dup\d+$/)
                     .delete('^0-9')
                     .to_i + 1
        end
        rubric_category = RubricCategory.new
        rubric_category.name = category_name
        rubric_category.slug = "#{category_slug}_dup#{size}"
        logger.debug("Creating duplicate category: #{rubric_category.slug}.")
      else
        rubric_category = RubricCategory.new
        rubric_category.name = category_name
        rubric_category.slug = category_slug
        logger.debug("Creating new category: #{rubric_category.slug}.")
      end
      rubric_category.weight = 1.0
      rubric_category.save!

      description = ''
      current_node = document_header.next_sibling
      until current_node.name == 'h2' && current_node.text == 'Indicators'
        description += current_node.to_html
        description += '<br />' unless current_node.to_html.blank?
        current_node = current_node.next_sibling
      end

      rubric_category_desc = RubricCategoryDescription.where(rubric_category_id: rubric_category.id,
                                                             locale: I18n.locale)
                                                      .first || RubricCategoryDescription.new
      rubric_category_desc.rubric_category_id = rubric_category.id
      rubric_category_desc.locale = I18n.locale
      rubric_category_desc.description = description
      rubric_category_desc.save

      indicators = html_fragment.css('tbody > tr')
      next if indicators.size <= 0

      indicators.each do |indicator|
        current_part = indicator.at_css('td')
        indicator_name = current_part.inner_html

        current_part = current_part.next_element
        indicator_source = current_part.inner_html

        current_part = current_part.next_element
        description_html = current_part.inner_html

        current_part = current_part.next_element
        indicator_type = current_part.inner_html

        indicator_slug = reslug_em(indicator_name)
        duplicate_indicators = CategoryIndicator.where(slug: indicator_slug)
                                                .order(slug: :desc)

        if duplicate_indicators.count.positive?
          first_duplicate = duplicate_indicators.first
          if first_duplicate.rubric_category_id == rubric_category.id
            # It's not a duplicate, so we should update this record.
            category_indicator = first_duplicate
            category_indicator.name = indicator_name
            logger.debug("Existing indicator found: #{category_indicator.slug}.")
          else
            # It's a duplicate because it's belong to a separate rubric.
            # Calculate the offset.

            dupe = CategoryIndicator.slug_starts_with(indicator_slug)
                                    .order(slug: :desc)
                                    .first
            size = 1
            unless dupe.nil?
              size = dupe.slug
                         .slice(/_dup\d+$/)
                         .delete('^0-9')
                         .to_i + 1
            end
            category_indicator = CategoryIndicator.new
            category_indicator.name = indicator_name
            category_indicator.slug = "#{indicator_slug}_dup#{size}"
            logger.debug("Creating duplicate indicator: #{category_indicator.slug}.")
          end
        else
          category_indicator = CategoryIndicator.new
          category_indicator.name = indicator_name
          category_indicator.slug = indicator_slug
          logger.debug("Creating new indicator: #{category_indicator.slug}.")
        end

        category_indicator.rubric_category = rubric_category
        category_indicator.data_source = indicator_source
        category_indicator.weight = (100.0 / indicators.count.to_f).round / 100.0
        category_indicator.source_indicator = indicator_name
        category_indicator.indicator_type = CategoryIndicator.category_indicator_types.key(indicator_type.downcase)
        category_indicator.save!

        category_indicator_desc = CategoryIndicatorDescription.where(category_indicator_id: category_indicator.id,
                                                                     locale: I18n.locale)
                                                              .first || CategoryIndicatorDescription.new
        category_indicator_desc.category_indicator_id = category_indicator.id
        category_indicator_desc.locale = I18n.locale
        category_indicator_desc.description = description_html
        category_indicator_desc.save
      end
    end
  end

  task :sync_legacy, [:path] => :environment do |_, _params|
    digisquare_maturity = YAML.load_file('data/yaml/maturity-digisquare.yml')
    digisquare_maturity.each do |digi_category|
      rubric_category = create_category(digi_category['core'])

      category_count = digi_category['sub-indicators'].count
      digi_category['sub-indicators'].each do |indicator|
        puts "Category: #{digi_category['core']} INDICATOR: #{indicator['name']}"
        create_indicator(indicator['name'], indicator['name'], 'Digital Square', category_count,
                         'scale', rubric_category.id)
      end
    end

    osc_maturity = YAML.load_file('config/maturity_osc.yml')
    osc_maturity.each do |osc_category|
      rubric_category = create_category(osc_category['header'])

      category_count = osc_category['items'].count
      osc_category['items'].each do |indicator|
        puts "Category: #{osc_category['header']} INDICATOR: #{indicator['code']}"
        create_indicator(indicator['code'], indicator['desc'], 'DIAL', category_count, 'boolean',
                         rubric_category.id)
      end
    end
  end

  task :update_maturity_scores, [:path] => :environment do |_, _params|
    task_name = 'Update Maturity Score'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    Product.all.each do |product|
      puts "Updating score for: #{product.name}."
      tracking_task_log(task_name, "Updating score for: #{product.name}.")
      calculate_maturity_scores(product.id)
      calculate_product_indicators(product.id, 'data/yaml/indicator-config.yml')
    end

    tracking_task_finish(task_name)
  end

  task :update_health_scores, [:path] => :environment do |_, _params|
    task_name = 'Update Health Maturity Score'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    Product.all.each do |product|
      puts "Updating score for: #{product.name}."
      tracking_task_log(task_name, "Updating score for: #{product.name}.")
      calculate_maturity_scores(product.id)
      calculate_product_indicators(product.id, 'config/maturity_health.yml')
    end

    tracking_task_finish(task_name)
  end

  task :update_license_data, [] => :environment do
    task_name = 'Update License Data'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    ProductRepository.all.each do |product_repository|
      tracking_task_log(task_name, "Updating license for: #{product_repository.product.name}.")
      sync_license_information(product_repository)
    end

    tracking_task_finish(task_name)
  end

  task :update_statistics_data, [] => :environment do
    task_name = 'Update Statistics Data'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    ProductRepository.all.each do |product_repository|
      tracking_task_log(task_name, "Updating statistics for: #{product_repository.product.name}.")
      sync_product_statistics(product_repository)
    end

    tracking_task_finish(task_name)
  end

  task :update_language_data, [] => :environment do
    task_name = 'Update Language Data'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    ProductRepository.all.each do |product_repository|
      tracking_task_log(task_name, "Updating language data for: #{product_repository.product.name}.")
      sync_product_languages(product_repository)
    end

    tracking_task_finish(task_name)
  end

  task :update_code_review_indicators, [] => :environment do
    task_name = 'Update Review Indicator Data'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    lang_file = YAML.load_file('utils/top_25_languages.yml')
    config_file = YAML.load_file('data/yaml/indicator-config.yml')

    Product.all.each do |product|
      tracking_task_log(task_name, "Updating indicator for: #{product.name}.")

      sync_license_indicator(product)
      sync_containerized_indicator(product)
      sync_documentation_indicator(product)
      sync_language_indicator(config_file, lang_file, product)
    end

    tracking_task_finish(task_name)
  end

  task :update_top_25_languages, [] => :environment do
    task_name = 'Update Top 25 Languages'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    read_languages_file

    tracking_task_finish(task_name)
  end

  task :update_products_languages, [] => :environment do
    task_name = 'Update Product Languages'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    Product.all.each do |product|
      tracking_task_log(task_name, "Updating languages for: #{product.name}.")

      product_repositories = ProductRepository.where(product_id: product.id)
      product_languages = []
      product_repositories.each do |repository|
        unless repository.language_data == {} || repository.language_data["data"]["repository"].nil?
          repo_languages = repository.language_data["data"]["repository"]["languages"]["edges"]
          product_languages << repo_languages
        end
      end

      product_languages = sum_languages(product_languages.flatten)

      unless product_languages[4..(product_languages.count - 1)].nil?
        counter = 0
        product_languages[4..(product_languages.count - 1)].each do |product_language|
          counter += product_language["size"]
        end
        if counter > 0
          product_languages.push({ "node" => { "name" => "Other", "color" => "#fd807f" }, "size" => counter })
        end
      end

      top_languages = (product_languages[0..2] << product_languages[-1]).flatten.uniq
      product.languages = top_languages
      product.languages = nil if top_languages == [nil]
      product.save!
    end

    tracking_task_finish(task_name)
  end

  task :update_api_docs_indicators, [] => :environment do
    task_name = 'Update Product API Indicators'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    ProductRepository.all.each do |product_repository|
      tracking_task_log(task_name, "Updating api indicators for: #{product_repository.product.name}.")
      api_check(product_repository)
    end
    tracking_task_finish(task_name)
  end
end
