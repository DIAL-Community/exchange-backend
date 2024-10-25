# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :model

  def initialize(current_user, record)
    super(current_user, record)
  end

  def available?
    true
  end

  def create_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin])
  end

  def edit_allowed?
    return false if user.nil?
    # Allow editing their own user record.
    return true if user.id == record.id

    user.roles.include?(User.user_roles[:admin])
  end

  def delete_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin])
  end

  def view_allowed?
    return false if user.nil?
    # Allow viewing their own user record.
    return true if user.id == record.id

    user.roles.include?(User.user_roles[:admin])
  end
end
