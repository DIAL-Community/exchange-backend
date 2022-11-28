# frozen_string_literal: true

class PlaybookDescription < ApplicationRecord
  include Auditable

  belongs_to :playbook
end
