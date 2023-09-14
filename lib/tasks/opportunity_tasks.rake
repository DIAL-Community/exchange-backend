# frozen_string_literal: true

namespace :opportunity do
  desc 'Nightly task to close opportunities.'
  task :close_opportunities, [:path] => :environment do |_, _|
    opportunities = Opportunity.where(opportunity_status: Opportunity.opportunity_status_types[:OPEN])
                               .where('closing_date < ?', Date.today)

    opportunities.each do |opportunity|
      puts "Processing: '#{opportunity.name}'."
      puts "  Status: #{opportunity.opportunity_status}, closing date: #{opportunity.closing_date}."
      opportunity.opportunity_status = Opportunity.opportunity_status_types[:CLOSED]
      if opportunity.save
        puts "  Updating status to: #{opportunity.opportunity_status}."
      end
    end
  end
end
