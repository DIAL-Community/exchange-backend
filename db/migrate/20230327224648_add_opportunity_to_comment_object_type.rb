# frozen_string_literal: true

class AddOpportunityToCommentObjectType < ActiveRecord::Migration[6.1]
  def up
    execute(<<-ALTER_SQL)
      ALTER TYPE comment_object_type RENAME TO comment_object_type_migrated;
      CREATE TYPE comment_object_type AS ENUM (
        'PRODUCT',
        'OPEN_DATA',
        'PROJECT',
        'USE_CASE',
        'BUILDING_BLOCK',
        'PLAYBOOK',
        'ORGANIZATION',
        'OPPORTUNITY'
      );
      ALTER TABLE comments
        ALTER COLUMN comment_object_type TYPE comment_object_type
          USING comment_object_type::text::comment_object_type;
      DROP TYPE comment_object_type_migrated;
    ALTER_SQL
  end

  def down
    execute(<<-ALTER_SQL)
      ALTER TYPE comment_object_type RENAME TO comment_object_type_migrated;
      CREATE TYPE comment_object_type AS ENUM (
        'PRODUCT',
        'OPEN_DATA',
        'PROJECT',
        'USE_CASE',
        'BUILDING_BLOCK',
        'PLAYBOOK',
        'ORGANIZATION'
      );
      ALTER TABLE comments
        ALTER COLUMN comment_object_type TYPE comment_object_type
          USING comment_object_type::text::comment_object_type;
      DROP TYPE comment_object_type_migrated;
    ALTER_SQL
  end
end
