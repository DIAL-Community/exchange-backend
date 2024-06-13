# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :created_by, class_name: 'User'

  after_create :trigger_message_notification

  def trigger_message_notification
    contacts = Contact.where(source: DPI_TENANT_NAME)
    contacts.each do |contact|
      MessageMailer
        .with(
          current_user: User.find_by(email: contact.email),
          current_contact: contact,
          current_message: self
        )
        .message_action_notification
        .deliver_now
    end
  end
end
