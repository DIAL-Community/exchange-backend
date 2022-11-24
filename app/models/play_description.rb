# frozen_string_literal: true

class PlayDescription < ApplicationRecord
  include Auditable

  belongs_to :play
end
