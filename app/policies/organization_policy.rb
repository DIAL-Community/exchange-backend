# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    super(user, record)
  end

  def available?
    true
  end

  def create_allowed?
    return false if user.nil?

    return true if !record.nil? && record.has_storefront.to_s == 'true'

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:content_editor]) ||
      user.roles.include?(User.user_roles[:content_writer])
  end

  def edit_allowed?
    return false if user.nil?

    if record.is_a?(Organization) && user.organization_id == record.id &&
      user.roles.include?(User.user_roles[:organization_owner])
      return true
    end

    if record.is_a?(Organization) && record.is_endorser &&
      user.roles.include?(User.user_roles[:principle])
      return true
    end

    if record.is_a?(Organization) && record.is_mni &&
      user.roles.include?(User.user_roles[:mni])
      return true
    end

    email_username, email_host = user.email.split('@')
    if record.is_a?(Organization) && email_username.nil? && website.to_s.include?(email_host)
      return true
    end

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:content_editor]) ||
      user.roles.include?(User.user_roles[:content_writer])
  end

  def delete_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin])
  end

  def view_allowed?
    current_tenant = ExchangeTenant.find_by(tenant_name: Apartment::Tenant.current)
    return true if current_tenant.nil? || current_tenant.allow_unsecured_read

    false
  end
end
