# frozen_string_literal: true

class AddDraftToEntityStatusType < ActiveRecord::Migration[6.1]
  def up
    execute(<<-ALTER_SQL)
      ALTER TYPE entity_status_type RENAME TO entity_status_type_migrated;
      CREATE TYPE entity_status_type AS ENUM (
        'BETA',
        'MATURE',
        'SELF-REPORTED',
        'VALIDATED',
        'PUBLISHED',
        'DRAFT'
      );
      ALTER TABLE use_cases
        ALTER COLUMN maturity DROP DEFAULT,
        ALTER COLUMN maturity TYPE entity_status_type
          USING maturity::text::entity_status_type,
        ALTER COLUMN maturity SET DEFAULT 'DRAFT'::entity_status_type;
      ALTER TABLE building_blocks
        ALTER COLUMN maturity DROP DEFAULT,
        ALTER COLUMN maturity TYPE entity_status_type
          USING maturity::text::entity_status_type,
        ALTER COLUMN maturity SET DEFAULT 'BETA'::entity_status_type;
      DROP TYPE entity_status_type_migrated;
    ALTER_SQL
  end

  def down
    execute(<<-ALTER_SQL)
      ALTER TYPE entity_status_type RENAME TO entity_status_type_migrated;
      CREATE TYPE entity_status_type AS ENUM (
        'BETA',
        'MATURE',
        'SELF-REPORTED',
        'VALIDATED',
        'PUBLISHED'
      );
      ALTER TABLE use_cases
        ALTER COLUMN maturity DROP DEFAULT,
        ALTER COLUMN maturity TYPE entity_status_type
          USING maturity::text::entity_status_type,
        ALTER COLUMN maturity SET DEFAULT 'BETA'::entity_status_type;
      ALTER TABLE building_blocks
        ALTER COLUMN maturity DROP DEFAULT,
        ALTER COLUMN maturity TYPE entity_status_type
          USING maturity::text::entity_status_type,
        ALTER COLUMN maturity SET DEFAULT 'BETA'::entity_status_type;
      DROP TYPE entity_status_type_migrated;
    ALTER_SQL
  end
end
