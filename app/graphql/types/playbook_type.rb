# frozen_string_literal: true

module Types
  class PlaybookDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :playbook_id, Integer, null: true
    field :locale, String, null: false
    field :overview, String, null: false
    field :audience, String, null: false
    field :outcomes, String, null: false
    field :cover, String, null: true

    field :sanitized_overview, String, null: false
    def sanitized_overview
      overview_html = Nokogiri::HTML.fragment(object.overview)
      overview_html.css('a').each { |node| node.replace(node.children) }

      first_paragraph = overview_html.at('p')

      first_paragraph.nil? ? overview_html.to_html : first_paragraph.inner_html
    end
  end

  class PlaybookPlayType < Types::BaseObject
    field :id, ID, null: false
    field :playbook_slug, String, null: true
    field :play_slug, String, null: true
    field :play_name, String, null: true
    field :play_order, Integer, null: true
  end

  class PlaybookType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :tags, GraphQL::Types::JSON, null: false
    field :phases, GraphQL::Types::JSON, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :maturity, String, null: true
    field :image_file, String, null: true
    field :author, String, null: true
    field :draft, Boolean, null: false

    field :playbook_descriptions, [Types::PlaybookDescriptionType], null: true
    field :playbook_description, Types::PlaybookDescriptionType, null: true,
                                                                 method: :playbook_description_localized

    field :playbook_plays, [Types::PlaybookPlayType], null: true,
                                                      method: :playbook_play_with_slug_list

    field :plays, [Types::PlayType], null: true
  end
end
