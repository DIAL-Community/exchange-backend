require 'devise/models/confirmable'

module Devise
  module Models
    module Confirmable
      extend ActiveSupport::Concern

      def pending_reconfirmation?
        unconfirmed_email.present?
      end

      # Send confirmation instructions by email
      def send_confirmation_instructions
        unless @raw_confirmation_token
          generate_confirmation_token!
        end

        opts = pending_reconfirmation? ? { to: unconfirmed_email, 'X-Tenant-ID': self.tenant_url } : { 'X-Tenant-ID': self.tenant_url }
        send_devise_notification(:confirmation_instructions, @raw_confirmation_token, opts)
      end

      def send_reconfirmation_instructions
        @reconfirmation_required = false

        unless @skip_confirmation_notification
          send_confirmation_instructions
        end
      end

      protected 

        def send_on_create_confirmation_instructions
          send_confirmation_instructions
        end

        # Generates a new random token for confirmation, and stores
        # the time this token is being generated in confirmation_sent_at
        def generate_confirmation_token
          if self.confirmation_token && !confirmation_period_expired?
            @raw_confirmation_token = self.confirmation_token
          else
            self.confirmation_token = @raw_confirmation_token = Devise.friendly_token
            self.confirmation_sent_at = Time.now.utc
          end
        end

        def generate_confirmation_token!
          generate_confirmation_token && save(validate: false)
        end

    end
  end
end
