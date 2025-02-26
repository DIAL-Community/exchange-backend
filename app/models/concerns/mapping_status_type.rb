# frozen_string_literal: true

module MappingStatusType
  extend ActiveSupport::Concern

  included do
    attribute :mapping_status_type, :string
    enum mapping_status_type: {
      BETA: 'BETA',
      MATURE: 'MATURE',
      SELF_REPORTED: 'SELF-REPORTED',
      VALIDATED: 'VALIDATED'
    }
  end
end
