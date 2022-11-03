# frozen_string_literal: true

module Modules
  module WizardHelpers
    def get_project_list(sector_ids, countries, tags, sort_hint, offset_params = {})
      sector_projects = ProjectsSector.where(sector_id: sector_ids).map(&:project_id)

      unless countries.nil?
        country_projects = ProjectsCountry.joins(:country).where(countries: { name: countries }).map(&:project_id)
      end

      unless tags.nil?
        tag_projects = []
        tags.each do |tag|
          tag_projects += Project.where(':tag = ANY(projects.tags)', tag: tag).map(&:id)
        end
      end

      project_list = filter_matching_projects(sector_projects, country_projects, tag_projects, sort_hint, offset_params)
      project_list.limit(20)
    end

    def filter_matching_projects(sector_projects, country_projects, tag_projects, sort_hint, offset_params)
      # Filter first by sector and tag and combine.
      # If there are more than 5 then find projects that match both sector and tag
      # If we have less than 10 results, add in projects that are connected to selected country
      sector_tag_projects = []
      sector_tag_projects = sector_projects unless sector_projects.nil?
      sector_tag_projects = (sector_tag_projects + tag_projects).uniq unless tag_projects.nil?
      if sector_tag_projects.length > 5
        # Find projects that match both sector and tag
        combined_projects = sector_projects & tag_projects
        sector_tag_projects = combined_projects if combined_projects && !combined_projects.empty?
      end

      if sector_tag_projects.length > 10 && !country_projects.nil?
        # Since we have several projects, try filtering by country
        combined_projects = sector_tag_projects & country_projects
        sector_tag_projects = combined_projects unless combined_projects.empty?
      end

      project_list = Project.all
      case sort_hint.to_s.downcase
      when 'country'
        project_list = project_list.joins(:countries).order('countries.name')
      when 'sector'
        project_list = project_list.joins(:sectors).order('sectors.name')
      when 'tag'
        project_list = project_list.order('tags')
      else
        project_list = project_list.order('name')
      end

      project_list = project_list.offset(offset_params[:offset]) unless offset_params.empty?

      project_list.where(id: sector_tag_projects)
    end

    def filter_matching_products(product_bb, product_project, product_sector, product_tag, product_use_case_steps,
      commercial_product, sort_hint, offset_params)
      # First, identify products that are aligned with selected sector and tags
      # Next, identify products that are aligned with needed building blocks
      # Finally, add products that are connected to relevant projects

      sector_tag_products = []
      sector_tag_products = product_sector unless product_sector.nil?
      sector_tag_products = (sector_tag_products + product_tag).uniq unless product_tag.nil?
      if sector_tag_products.length > 5
        # Find projects that match both sector and tag
        combined_products = product_sector & product_tag
        sector_tag_products = combined_products if combined_products && combined_products.length > 2
      end

      if sector_tag_products.length > 10 && !product_bb.nil?
        # Since we have several products, try filtering by BB
        combined_products = sector_tag_products & product_bb
        sector_tag_products = combined_products if combined_products && combined_products.length > 2
      elsif sector_tag_products.empty? && !product_bb.nil?
        sector_tag_products = product_bb
      end

      if sector_tag_products.length > 10 && !product_project.nil?
        # Since we have several products, try filtering by project
        combined_products = sector_tag_products & product_project
        sector_tag_products = combined_products if combined_products && combined_products.length > 4
      elsif sector_tag_products.empty? && !product_project.nil?
        sector_tag_products = product_project
      end

      if sector_tag_products.length > 10 && !product_use_case_steps
        # Since we have several products, try filtering by use case steps
        combined_products = sector_tag_products & product_use_case_steps
        sector_tag_products = combined_products if combined_products && combined_products.length > 4
      elsif sector_tag_products.empty? && !product_use_case_steps.nil?
        sector_tag_products = product_use_case_steps
      end

      product_list = Product.all
      case sort_hint.to_s.downcase
      when 'country'
        product_list = product_list.joins(:countries).order('countries.name')
      when 'sector'
        product_list = product_list.joins(:sectors).order('sectors.name')
      when 'tag'
        product_list = product_list.order('tags')
      else
        product_list = product_list.order('name')
      end

      product_list = product_list.offset(offset_params[:offset]) unless offset_params.empty?

      unless commercial_product.nil?
        product_list = product_list.where(commercial_product: commercial_product)
      end

      product_list.where(id: sector_tag_products).limit(20)
    end

    def filter_matching_playbooks(playbook_sector, playbook_tag, sort_hint, offset_params)
      combined_playbooks = playbook_sector & playbook_tag
      sector_tag_playbooks = combined_playbooks unless combined_playbooks.nil?

      playbook_list = Playbook.all
      case sort_hint.to_s.downcase
      when 'sector'
        playbook_list = playbook_list.joins(:sectors).order('sectors.name')
      when 'tag'
        playbook_list = playbook_list.order('tags')
      else
        playbook_list = playbook_list.order('name')
      end

      playbook_list = playbook_list.offset(offset_params[:offset]) unless offset_params.empty?

      playbook_list.where(id: sector_tag_playbooks).limit(20)
    end
  end
end
