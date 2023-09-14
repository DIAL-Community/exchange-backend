# frozen_string_literal: true

module Queries
  class PlaybooksQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::PlaybookType], null: false

    def resolve(search:)
      playbooks = Playbook.all.order(:name)
      playbooks = playbooks.name_contains(search) unless search.blank?
      playbooks
    end
  end

  class PlaybookQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::PlaybookType, null: true

    def resolve(slug:)
      playbook = Playbook.find_by(slug:)

      return nil if playbook&.draft == true && !(an_admin || a_content_editor)

      playbook
    end
  end

  class SearchPlaybookTagsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''

    type [Types::TagType], null: false

    def resolve(search:)
      used_tags = []
      Playbook.all.each do |playbook|
        used_tags += playbook.tags
      end

      tags = Tag.where(name: used_tags)
      if !search.nil? && !search.to_s.strip.empty?
        tags = tags.name_contains(search)
      end
      tags
    end
  end
end
