# frozen_string_literal: true

class NilClassPolicy < ApplicationPolicy
  def available?
    false
  end

  def create_allowed?
    false
  end

  def edit_allowed?
    false
  end

  def delete_allowed?
    false
  end

  def view_allowed?
    false
  end
end
