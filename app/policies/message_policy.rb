# frozen_string_literal: true

class MessagePolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    super(user, record)
  end

  def available?
    true
  end

  def create_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:adli_admin])
  end

  def edit_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:adli_admin])
  end

  def delete_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin])
  end

  def view_allowed?
    return false if user.nil?

    current_tenant = ExchangeTenant.find_by(tenant_name: Apartment::Tenant.current)
    return true if current_tenant.nil? || current_tenant.allow_unsecured_read

    false
  end
end
