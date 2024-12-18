# frozen_string_literal: true

class AddingMissingCommentObjectTypes < ActiveRecord::Migration[7.0]
  def up
    execute(<<-ALTER_SQL)
      ALTER TYPE comment_object_type RENAME TO comment_object_type_migrated;
      CREATE TYPE comment_object_type AS ENUM (
        'BUILDING_BLOCK',
        'OPEN_DATA',
        'PRODUCT',
        'PROJECT',
        'OPPORTUNITY',
        'ORGANIZATION',
        'USE_CASE',
        'WORKFLOW',
        'MOVE',
        'PLAY',
        'PLAYBOOK',
        'RUBRIC_CATEGORY',
        'CATEGORY_INDICATOR',
        'CANDIDATE_OPEN_DATA',
        'CANDIDATE_ORGANIZATION',
        'CANDIDATE_PRODUCT',
        'CANDIDATE_RESOURCE',
        'CANDIDATE_ROLE',
        'TAG',
        'SECTOR',
        'CITY',
        'COUNTRY',
        'REGION',
        'TASK',
        'USER',
        'CONTACT',
        'RESOURCE',
        'RESOURCE_TOPIC',
        'SITE_SETTING',
        'TENANT_SETTING'
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
        'ORGANIZATION',
        'OPPORTUNITY',
        'CANDIDATE_OPEN_DATA',
        'CANDIDATE_ORGANIZATION',
        'CANDIDATE_PRODUCT',
        'CANDIDATE_ROLE',
        'TAG',
        'SECTOR',
        'COUNTRY',
        'CITY',
        'CONTACT',
        'RESOURCE',
        'PLAY',
        'SITE_SETTING',
        'TENANT_SETTING',
        'CANDIDATE_RESOURCE'
      );
      ALTER TABLE comments
        ALTER COLUMN comment_object_type TYPE comment_object_type
          USING comment_object_type::text::comment_object_type;
      DROP TYPE comment_object_type_migrated;
    ALTER_SQL
  end
end
