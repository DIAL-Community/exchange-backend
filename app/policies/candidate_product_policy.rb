# frozen_string_literal: true

class CandidateProductPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    super(user, record)
  end

  def available?
    true
  end

  def create_allowed?
    !user.nil?
  end

  def edit_allowed?
    return false if user.nil?
    return true if user.id == record.created_by_id

    user.roles.include?(User.user_roles[:admin])
  end

  def delete_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin])
  end

  def view_allowed?
    !user.nil?
  end
end
