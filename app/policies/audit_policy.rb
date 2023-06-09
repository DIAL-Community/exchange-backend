# frozen_string_literal: true

class AuditPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    super(user, record)
  end

  def view_allowed?
    !user.nil? && user.roles.include?(User.user_roles[:admin])
  end
end
