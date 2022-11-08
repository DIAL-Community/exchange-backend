# frozen_string_literal: true

organizations = Organization.all.where.not(when_endorsed: nil)
organizations.each do |organization|
  organization.when_endorsed = organization.when_endorsed.change(hour: 12)
  organization.save!
end
