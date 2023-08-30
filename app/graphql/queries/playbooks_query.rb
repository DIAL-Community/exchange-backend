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

  class SearchPlaybooksQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    argument :products, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []

    type Types::PlaybookType.connection_type, null: false

    # TODO: Disabling rubocop here as we will use the products param eventually.
    # rubocop:disable Lint/UnusedMethodArgument
    def resolve(search:, products:, tags:)
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

      # Commenting this one out until we can assign product to plays.
      # filtered_products = products.reject { |x| x.nil? || x.empty? }
      # unless filtered_products.empty?
      #   play_ids = Play.joins(:products)
      #                  .where(products: { id: filtered_products })
      #                  .select('id')
      #   playbooks.joins(:plays).where(plays: { id: play_ids })
      # end

      playbooks.distinct
    end
  end
  # rubocop:enable Lint/UnusedMethodArgument

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

  class PaginatedPlaybooksQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper
    include Queries

    argument :sectors, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    argument :playbook_sort_hint, String, required: false, default_value: 'name'

    type Types::PlaybookType.connection_type, null: false

    def resolve(sectors:, tags:, playbook_sort_hint:, offset_attributes:)
      wizard_playbooks(sectors, tags, playbook_sort_hint, offset_attributes)
    end
  end

  def wizard_playbooks(sectors, tags, sort_hint, offset_params = {})
    sectors_playbooks = Playbook.joins(:sectors).where(sectors: { name: sectors, locale: I18n.locale }).map(&:id)

    unless tags.nil?
      tag_playbooks = []
      tags.each do |tag|
        tag_playbooks += Playbook.where('LOWER(:tag) = ANY(LOWER(tags::text)::text[])', tag:).map(&:id)
      end
    end

    filter_matching_playbooks(sectors_playbooks, tag_playbooks, sort_hint, offset_params).uniq
  end
end
