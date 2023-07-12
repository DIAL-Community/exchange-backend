# frozen_string_literal: true

class AddColumnFeaturedToProjectsOrganizationsTable < ActiveRecord::Migration[7.0]
  def change
    add_column(:projects_organizations, :featured_project, :boolean, null: false, default: false)
  end
end
