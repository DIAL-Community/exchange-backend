# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateCandidateResource < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :description, String, required: true
    argument :published_date, GraphQL::Types::ISO8601Date, required: true

    argument :resource_type, String, required: true
    argument :resource_link, String, required: true
    argument :link_description, String, required: true

    argument :country_slugs, [String], required: true

    argument :submitter_email, String, required: true
    argument :captcha, String, required: true

    field :candidate_resource, Types::CandidateResourceType, null: true
    field :errors, [String], null: true

    def resolve(
      name:, slug:, description:, published_date:,
      resource_type:, resource_link:, link_description:,
      country_slugs:, submitter_email:, captcha:
    )
      candidate_resource = CandidateResource.find_by(slug:)
      candidate_resource_policy = Pundit.policy(
        context[:current_user],
        candidate_resource || CandidateResource.new
      )
      unless candidate_resource_policy.edit_allowed?
        return {
          candidate_resource: nil,
          errors: ['Creating / editing candidate resource is not allowed.']
        }
      end

      if candidate_resource.nil?
        slug = reslug_em(name)
        candidate_resource = CandidateResource.new(name:, slug:)

        # Check if we need to add _dup to the slug.
        first_duplicate = CandidateResource.slug_simple_starts_with(slug)
                                           .order(slug: :desc)
                                           .first
        unless first_duplicate.nil?
          candidate_resource.slug = slug + generate_offset(first_duplicate)
        end
      elsif candidate_resource.nil? && candidate_resource.rejected.nil?
        return {
          candidate_resource: nil,
          errors: ['Attempting to edit rejected or approved candidate resource.']
        }
      end

      candidate_resource.name = name
      candidate_resource.resource_type = resource_type
      candidate_resource.resource_link = resource_link
      candidate_resource.link_description = link_description
      candidate_resource.submitter_email = submitter_email
      candidate_resource.description = description

      unless published_date.nil?
        date = published_date.to_s
        timestamp = Time.new(date[0..3], date[5..6], date[8..9], 12, 0, 0, "+00:00")
        candidate_resource.published_date = timestamp
      end

      candidate_resource.countries = []
      if !country_slugs.nil? && !country_slugs.empty?
        country_slugs.each do |country_slug|
          current_country = Country.find_by(slug: country_slug)
          candidate_resource.countries << current_country unless current_country.nil?
        end
      end

      if candidate_resource.save! && captcha_verification(captcha)
        AdminMailer
          .with(
            candidate_name: candidate_resource.name,
            object_type: 'Candidate Resource'
          )
          .notify_new_candidate_record
          .deliver_now
        # Successful creation, return the created object with no errors
        {
          candidate_resource:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          candidate_resource: nil,
          errors: candidate_resource.errors.full_messages
        }
      end
    end
  end
end
