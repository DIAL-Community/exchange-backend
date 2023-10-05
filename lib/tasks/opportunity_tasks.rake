# frozen_string_literal: true

namespace :opportunity do
  desc 'Nightly task to close opportunities.'
  task :close_opportunities, [:path] => :environment do |_, _|
    task_name = 'Closing Leverist RFP'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    opportunities = Opportunity.where(opportunity_status: Opportunity.opportunity_status_types[:OPEN])
                               .where('closing_date < ?', Date.today)

    opportunities.each do |opportunity|
      opportunity.opportunity_status = Opportunity.opportunity_status_types[:CLOSED]
      tracking_task_log(task_name, "Closing RFP: #{opportunity.name}, due date: #{opportunity.closing_date}.")
      if opportunity.save!
        puts "Closing RFP: #{opportunity.name}."
      end
    end

    tracking_task_finish(task_name)
  end
end
