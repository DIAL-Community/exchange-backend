# frozen_string_literal: true

class BuildingBlockPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    super(user, record)
  end

  def available?
    # TODO: Initial implementation of CDS-2062.
    # Implementation will be as follows:
    # - Use this to toggle the availability of a building block section.
    # - We can store the toggle in database and query them for the value (or config file).
    # - Query will return 'BAD_REQUEST' if it is not available. UI will re-route to the home page.
    # - For now, we are just returning false
    true
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
