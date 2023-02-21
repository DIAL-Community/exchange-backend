# frozen_string_literal: true

class OrganizationDescription < ApplicationRecord
  include Auditable

  belongs_to :organization
end
