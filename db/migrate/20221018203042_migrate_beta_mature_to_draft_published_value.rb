# frozen_string_literal: true

class MigrateBetaMatureToDraftPublishedValue < ActiveRecord::Migration[6.1]
  def up
    execute(<<-UPDATE_SQL)
      UPDATE use_cases set maturity = 'DRAFT' where maturity = 'BETA';
      UPDATE use_cases set maturity = 'PUBLISHED' where maturity = 'MATURE';
    UPDATE_SQL
  end

  def down
    execute(<<-UPDATE_SQL)
      UPDATE use_cases set maturity = 'BETA' where maturity = 'DRAFT';
      UPDATE use_cases set maturity = 'MATURE' where maturity = 'PUBLISHED';
    UPDATE_SQL
  end
end
