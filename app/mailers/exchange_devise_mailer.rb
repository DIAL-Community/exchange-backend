# frozen_string_literal: true
class ExchangeDeviseMailer < Devise::Mailer
  def confirmation_instructions(record, token, opts = {})
    @token = token
    tenant_domain = "exchange.dial.global"
    # Our mailer (Mandrill) requires all domains to be registered. If we can register
    #  the domain in the mailer, then we can use the tenant domain for emails
    # tenant = ExchangeTenant.where(tenant_name: Apartment::Tenant.current).last
    # tenant_domain = tenant.domain if tenant.present?
    opts[:from] = "notifier@#{tenant_domain}"
    opts[:reply_to] = "notifier@#{tenant_domain}"
    devise_mail(record, :confirmation_instructions, opts)
  end

  def password_change(record, token, opts = {})
    @token = token
    tenant_domain = "exchange.dial.global"
    # Our mailer (Mandrill) requires all domains to be registered. If we can register
    #  the domain in the mailer, then we can use the tenant domain for emails
    # tenant = ExchangeTenant.where(tenant_name: Apartment::Tenant.current).last
    # tenant_domain = tenant.domain if tenant.present?
    opts[:from] = "notifier@#{tenant_domain}"
    opts[:reply_to] = "notifier@#{tenant_domain}"
    devise_mail(record, :password_change, opts)
  end

  def reset_password_instructions(record, token, opts = {})
    @token = token
    tenant_domain = "exchange.dial.global"
    # Our mailer (Mandrill) requires all domains to be registered. If we can register
    #  the domain in the mailer, then we can use the tenant domain for emails
    # tenant = ExchangeTenant.where(tenant_name: Apartment::Tenant.current).last
    # tenant_domain = tenant.domain if tenant.present?
    opts[:from] = "notifier@#{tenant_domain}"
    opts[:reply_to] = "notifier@#{tenant_domain}"
    devise_mail(record, :reset_password_instructions, opts)
  end
end
