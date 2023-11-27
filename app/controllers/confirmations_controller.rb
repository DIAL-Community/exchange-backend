# frozen_string_literal: true
class ConfirmationsController < Devise::ConfirmationsController
  def create
    user = User.find_by(email: resource_params[:email])
    user.tenant_url = request.origin + "/"
    self.resource = user.send_confirmation_instructions
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end

  private

  def after_resending_confirmation_instructions_path_for(_resource_name)
    '/auth/signin'
  end

  def after_confirmation_path_for(_resource_name, _resource)
    '/auth/signin'
  end
end
