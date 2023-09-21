# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    null true

    field_class Types::BaseField
    object_class Types::BaseObject

    def ready?(**_args)
      # Called with mutation args.
      # Use keyword args such as employee_id: or **args to collect them
      true
    end

    def assign_auditable_user(mutating_object)
      if !mutating_object.nil? && mutating_object.class.method_defined?(:auditable_current_user)
        mutating_object.auditable_current_user(context[:current_user])
      end
    end

    def an_admin
      return false if context[:current_user].nil?

      context[:current_user].roles.include?('admin')
    end

    def a_product_owner(product_id)
      return false if product_id.nil? || context[:current_user].nil?

      context[:current_user].user_products.include?(product_id)
    end

    def an_org_owner(organization_id)
      return false if organization_id.nil? || context[:current_user].nil?

      context[:current_user].organization_id.equal?(organization_id)
    end

    def a_dataset_owner(dataset_id)
      return false if dataset_id.nil? || context[:current_user].nil?

      context[:current_user].user_datasets.include?(dataset_id)
    end

    def a_content_editor
      return false if context[:current_user].nil?

      context[:current_user].roles.include?('content_editor')
    end

    def product_owner_check_for_project(project)
      products = project.products
      products.each do |product|
        if a_product_owner(product.id)
          return true
        end
      end
      false
    end

    def org_owner_check_for_project(project)
      organizations = project.organizations
      organizations.each do |organization|
        if an_org_owner(organization.id)
          return true
        end
      end
      false
    end

    def generate_offset(first_duplicate)
      size = 0
      if !first_duplicate.nil? && first_duplicate.slug.include?('_dup')
        size = first_duplicate.slug
                              .slice(/_dup\d+$/)
                              .delete('^0-9')
                              .to_i + 1
      end
      "_dup#{size}"
    end

    def captcha_verification(captcha)
      Recaptcha.verify_via_api_call(captcha,
                                    {
                                      secret_key: Rails.application.secrets.captcha_secret_key,
                                      skip_remote_ip: true
                                    })
    end
  end
end
