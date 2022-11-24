# frozen_string_literal: true

module EntityStatusType
  extend ActiveSupport::Concern

  included do
    enum entity_status_type: {
      BETA: 'BETA',
      MATURE: 'MATURE',
      SELF_REPORTED: 'SELF-REPORTED',
      VALIDATED: 'VALIDATED',
      PUBLISHED: 'PUBLISHED',
      DRAFT: 'DRAFT'
    }
  end
end
