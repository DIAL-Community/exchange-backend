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
    field :draft, Boolean, null: false
    field :image_file, String, null: false

    field :tags, GraphQL::Types::JSON, null: false
    field :phases, GraphQL::Types::JSON, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :author, String, null: true

    field :playbook_descriptions, [Types::PlaybookDescriptionType], null: true
    field :playbook_description, Types::PlaybookDescriptionType, null: true,
                                                                 method: :playbook_description_localized

    field :playbook_plays, [Types::PlaybookPlayType], null: true
    def playbook_plays
      current_user = context[:current_user]
      if current_user.nil?
        if object.owned_by == DPI_TENANT_NAME
          # Some part of DPI pages are for logged in users only, but they're not a tenant.
          # Different approach to lock part of the entities.
          return []
        else
          return object.all_playbook_plays
        end
      end

      an_admin = current_user.roles.include?('admin')
      an_adli_admin = current_user.roles.include?('adli_admin')

      if an_admin || an_adli_admin
        object.all_playbook_plays
      else
        object.published_playbook_plays
      end
    end

    field :plays, [Types::PlayType], null: true
    def plays
      current_user = context[:current_user]
      if current_user.nil?
        if object.owned_by == DPI_TENANT_NAME
          return []
        else
          return object.all_plays
        end
      end

      an_admin = current_user.roles.include?('admin')
      an_adli_admin = current_user.roles.include?('adli_admin')

      if an_admin || an_adli_admin
        object.all_plays
      else
        object.published_plays
      end
    end

    field :owned_by, String, null: false
  end
end
