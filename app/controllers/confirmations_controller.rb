# frozen_string_literal: true
class ConfirmationsController < Devise::ConfirmationsController
  private

  def after_resending_confirmation_instructions_path_for(_resource_name)
    '/auth/signin'
  end

  def after_confirmation_path_for(_resource_name, _resource)
    '/auth/signin'
  end
end
