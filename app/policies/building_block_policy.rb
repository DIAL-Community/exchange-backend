# frozen_string_literal: true

class BuildingBlockPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    super(user, record)
  end

  def update_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:content_editor]) ||
      user.roles.include?(User.user_roles[:content_writer])
  end

  def delete_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin])
  end

  def view_allowed?
    true
  end
end
