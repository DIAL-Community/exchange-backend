# frozen_string_literal: true

class AddNotificationTemplateToCandidateStatuses < ActiveRecord::Migration[7.0]
  def change
    default_template = <<-NOTIFICATION_TEMPLATE
      <p>
        Hi {{current-user}},
      </p>
      <p>
        Your candidate's status, '{{candidate-name}}', has been updated.
      </p>
      <p>
        The previous status was '{{previous-status}}' and the current status is '{{current-status}}'.
      </p>
    NOTIFICATION_TEMPLATE
    add_column(:candidate_statuses, :notification_template, :string, null: false, default: default_template)
  end
end
