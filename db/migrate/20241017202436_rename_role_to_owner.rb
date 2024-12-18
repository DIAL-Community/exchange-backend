# frozen_string_literal: true

class RenameRoleToOwner < ActiveRecord::Migration[7.0]
  def up
    execute(<<-ALTER_SQL)
      ALTER TYPE user_role RENAME VALUE 'product_user' TO 'product_owner';
      ALTER TYPE user_role RENAME VALUE 'org_user' TO 'organization_owner';
    ALTER_SQL
  end

  def down
    execute(<<-ALTER_SQL)
      ALTER TYPE user_role RENAME VALUE 'product_owner' TO 'product_user';
      ALTER TYPE user_role RENAME VALUE 'organization_owner' TO 'org_user';
    ALTER_SQL
  end
end
