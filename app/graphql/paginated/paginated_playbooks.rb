# frozen_string_literal: true

module Paginated
  class PaginatedPlaybooks < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :tags, [String], required: false, default_value: []
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::PlaybookType], null: false

    def resolve(search:, tags:, offset_attributes:)
      playbooks = Playbook.all.order(:name)
      unless an_admin || a_content_editor
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
          "tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or " \
          "tags @> '{#{filtered_tags.join(',')}}'::varchar[]"
        )
      end

      offset_params = offset_attributes.to_h
      playbooks.limit(offset_params[:limit]).offset(offset_params[:offset]).distinct
    end
  end
end