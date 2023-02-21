# frozen_string_literal: true

class ChangeProductMaturityScoreColumnType < ActiveRecord::Migration[6.1]
  def change
    execute(<<-ALTER_SQL)
      ALTER TABLE products ALTER COLUMN maturity_score TYPE JSONB USING maturity_score::varchar::JSONB;
    ALTER_SQL
  end
end
