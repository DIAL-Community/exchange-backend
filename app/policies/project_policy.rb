# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    super(user, record)
  end

  def mod_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:organization_owner]) ||
      user.roles.include?(User.user_roles[:product_owner])
  end

  def view_allowed?
    true
  end
end
