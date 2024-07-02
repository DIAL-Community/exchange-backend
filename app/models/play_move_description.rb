# frozen_string_literal: true

class PlayMoveDescription < ApplicationRecord
  include Auditable

  belongs_to :play_move
end
