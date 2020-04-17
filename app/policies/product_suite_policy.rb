class ProductSuitePolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def permitted_attributes
    [:id, :name, :slug, :description]
  end

  def mod_allowed?
    user.role == 'admin'
  end

  def view_allowed?
    true
  end
end