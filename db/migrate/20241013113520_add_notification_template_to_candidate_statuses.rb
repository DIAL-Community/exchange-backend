# frozen_string_literal: true

class AddNotificationTemplateToCandidateStatuses < ActiveRecord::Migration[7.0]
  def change
    default_template = <<-NOTIFICATION_TEMPLATE
      <p>
        Hi {recipientUsername},
      </p>
      <p>
        Your candidate status {submissionLink} has been updated.
      </p>
    NOTIFICATION_TEMPLATE
    add_column(:candidate_statuses, :notification_template, :string, null: false, default: default_template)
  end
end
