# frozen_string_literal: true

class UserEvent < ApplicationRecord
  attribute :event_type, :string
  enum event_type: {
    login_success: 'LOGIN SUCCESS', login_failed: 'LOGIN FAILED', index_view: 'INDEX VIEW',
    page_view: 'PAGE VIEW', product_view: 'PRODUCT VIEW', initial_load: 'INITIAL PAGE LOAD',
    api_request: 'API REQUEST'
  }
end
