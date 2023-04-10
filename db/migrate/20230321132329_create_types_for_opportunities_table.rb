# frozen_string_literal: true

class CreateTypesForOpportunitiesTable < ActiveRecord::Migration[6.1]
  def up
    execute(<<-ALTER_SQL)
      CREATE TYPE opportunity_status_type AS ENUM (
        'UPCOMING',
        'OPEN',
        'CLOSED'
      );
      CREATE TYPE opportunity_type_type AS ENUM (
        'BID',
        'TENDER',
        'INNOVATION',
        'BUILDING BLOCK',
        'OTHER'
      );
    ALTER_SQL
  end

  def down
    execute(<<-ALTER_SQL)
      DROP TYPE opportunity_status_type;
      DROP TYPE opportunity_type_type;
    ALTER_SQL
  end
end
