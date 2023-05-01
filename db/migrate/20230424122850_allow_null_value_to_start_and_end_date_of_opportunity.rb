# frozen_string_literal: true

class AllowNullValueToStartAndEndDateOfOpportunity < ActiveRecord::Migration[6.1]
  def up
    change_column(:opportunities, :opening_date, :datetime, default: nil, null: true)
    change_column(:opportunities, :closing_date, :datetime, default: nil, null: true)
  end

  def down
    change_column(:opportunities, :opening_date, :datetime, default: -> { 'CURRENT_TIMESTAMP' }, null: false)
    change_column(:opportunities, :closing_date, :datetime, default: -> { 'CURRENT_TIMESTAMP' }, null: false)
  end
end
