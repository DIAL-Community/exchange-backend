# frozen_string_literal: true

class ChatbotConversationPolicy < ApplicationPolicy
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
    current_tenant = ExchangeTenant.find_by(tenant_name: Apartment::Tenant.current)
    return true if current_tenant.nil? || current_tenant.allow_unsecured_read

    false
  end
end
