# frozen_string_literal: true

class TagDescription < ApplicationRecord
  include Auditable

  belongs_to :tag
end
