# frozen_string_literal: true

class ContactPolicy < ApplicationPolicy
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
    return true if user.email == record.email

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:adli_admin])
  end

  def delete_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin])
  end

  def view_allowed?
    return false if user.nil?
    return true if user.email == record.email

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:adli_admin])
  end
end
