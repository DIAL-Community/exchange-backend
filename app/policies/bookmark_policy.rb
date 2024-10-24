# frozen_string_literal: true

class BookmarkPolicy < ApplicationPolicy
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
    !user.nil?
  end

  def delete_allowed?
    !user.nil?
  end

  def view_allowed?
    !user.nil?
  end
end
