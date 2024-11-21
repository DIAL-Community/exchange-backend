# frozen_string_literal: true

class UpdateUserRoleList < ActiveRecord::Migration[7.0]
  def up
    execute(<<-ALTER_SQL)
      ALTER TYPE user_role RENAME TO user_role_migrated;
      CREATE TYPE user_role AS ENUM (
        'admin',
        'ict4sdg',
        'principle',
        'user',
        'organization_owner',
        'product_owner',
        'mni',
        'content_writer',
        'content_editor',
        'dataset_user',
        'adli_admin',
        'adli_user',
        'candidate_editor'
        );
      ALTER TABLE candidate_roles
        ALTER COLUMN roles DROP DEFAULT,
        ALTER COLUMN roles TYPE user_role[]
          USING roles::text::user_role[],
        ALTER COLUMN roles SET DEFAULT '{}'::user_role[];
      ALTER TABLE users
        ALTER COLUMN roles DROP DEFAULT,
        ALTER COLUMN roles TYPE user_role[]
          USING roles::text::user_role[],
        ALTER COLUMN roles SET DEFAULT '{}'::user_role[];
      DROP TYPE user_role_migrated;
    ALTER_SQL
  end

  def down
    execute(<<-ALTER_SQL)
    ALTER TYPE user_role RENAME TO user_role_migrated;
    CREATE TYPE user_role AS ENUM (
        'admin',
        'ict4sdg',
        'principle',
        'user',
        'organization_owner',
        'org_product_user',
        'product_owner',
        'mni',
        'content_writer',
        'content_editor',
        'dataset_user',
        'adli_admin',
        'adli_user'
      );
    ALTER TABLE candidate_roles
      ALTER COLUMN roles DROP DEFAULT,
      ALTER COLUMN roles TYPE user_role[]
        USING roles::text::user_role[],
      ALTER COLUMN roles SET DEFAULT '{}'::user_role[];
    ALTER TABLE users
      ALTER COLUMN roles DROP DEFAULT,
      ALTER COLUMN roles TYPE user_role[]
        USING roles::text::user_role[],
      ALTER COLUMN roles SET DEFAULT '{}'::user_role[];
    DROP TYPE user_role_migrated;
    ALTER_SQL
  end
end
