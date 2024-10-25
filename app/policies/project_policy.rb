# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
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
      user.roles.include?(User.user_roles[:content_editor]) ||
      user.roles.include?(User.user_roles[:content_writer])
  end

  def edit_allowed?
    return false if user.nil?

    product_ids = record.products.map(&:id)
    organization_ids = record.organizations.map(&:id)

    if user.roles.include?(User.user_roles[:product_owner]) &&
      !(product_ids & user.user_products).empty?
      return true
    end

    if user.roles.include?(User.user_roles[:organization_owner]) &&
      organization_ids.include?(user.organization_id)
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
