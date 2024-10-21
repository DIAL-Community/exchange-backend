# frozen_string_literal: true

module Paginated
  class PaginationAttributePlaybook < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :owner, String, required: true
    argument :tags, [String], required: false, default_value: []

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, owner:, tags:)
      if !unsecured_read_allowed && context[:current_user].nil?
        return { total_count: 0 }
      end

      playbooks = Playbook.where(owned_by: owner).order(:name)
      unless an_admin || a_content_editor || an_adli_admin
        playbooks = playbooks.where(draft: false)
      end

      if !search.nil? && !search.to_s.strip.empty?
        name_playbooks = playbooks.name_contains(search)
        desc_playbooks = playbooks.joins(:playbook_descriptions)
                                  .where('LOWER(overview) like LOWER(?)', "%#{search}%")
        playbooks = playbooks.where(id: (name_playbooks + desc_playbooks).uniq)
      end

      filtered_tags = tags.reject { |x| x.nil? || x.blank? }
      unless filtered_tags.empty?
        playbooks = playbooks.where(
          "playbooks.tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or " \
          "playbooks.tags @> '{#{filtered_tags.join(',')}}'::varchar[]"
        )
      end

      { total_count: playbooks.distinct.count }
    end
  end
end
