# frozen_string_literal: true

module Queries
  class PlaybookQuery < Queries::BaseQuery
    argument :slug, String, required: true
    argument :owner, String, required: true

    type Types::PlaybookType, null: true

    def resolve(slug:, owner:)
      playbook = Playbook.find_by(slug:, owned_by: owner)

      return nil if playbook&.draft == true && !(an_admin || a_content_editor || an_adli_admin)

      playbook
    end
  end

  class PlaybooksQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :owner, String, required: true

    type [Types::PlaybookType], null: false

    def resolve(search:, owner:)
      playbooks = Playbook.where(owned_by: owner).order(:name)
      playbooks = playbooks.name_contains(search) unless search.blank?
      playbooks
    end
  end

  class SearchPlaybookTagsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :owner, String, required: true

    type [Types::TagType], null: false

    def resolve(search:, owner:)
      used_tags = []
      Playbook.where(owned_by: owner).each do |playbook|
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
