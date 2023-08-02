# frozen_string_literal: true

module Queries
  class OwnersQuery < Queries::BaseQuery
    argument :slug, String, required: true
    argument :type, String, required: true
    argument :captcha, String, required: true

    type [Types::UserType], null: false

    def resolve(slug:, type:, captcha:)
      return [] if context[:current_user].nil?

      captcha_validation = Recaptcha.verify_via_api_call(captcha, {
        secret_key: Rails.application.secrets.captcha_secret_key,
        skip_remote_ip: true
      })
      return [] unless captcha_validation

      if type == 'PRODUCT'
        product = Product.find_by(slug:)
        unless product.nil?
          owners = User.where(':product_id = ANY(user_products)', product_id: product.id)
                       .select('email')
        end
      elsif type == 'ORGANIZATION'
        organization = Organization.find_by(slug:)
        unless organization.nil?
          owners = User.where(':organization_id = organization_id', organization_id: organization.id)
                       .select('email')
        end
      end
      owners
    end
  end
end
