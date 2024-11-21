# frozen_string_literal: true

class DropUnusedEnumTypes < ActiveRecord::Migration[7.0]
  def up
    execute(<<-ALTER_SQL)
      DROP TYPE IF EXISTS top_nav;
      DROP TYPE IF EXISTS filter_nav;
      DROP TYPE IF EXISTS org_type_orig;
      DROP TYPE IF EXISTS org_type_save;

      ALTER TABLE products
        ALTER COLUMN product_type DROP DEFAULT,
        ALTER COLUMN product_type TYPE product_type
          USING product_type::text::product_type,
        ALTER COLUMN product_type SET DEFAULT 'product'::product_type;
      DROP TYPE IF EXISTS product_type_save;

      ALTER TYPE org_type RENAME TO organization_type;
    ALTER_SQL
  end

  def down
    execute(<<-ALTER_SQL)
      ALTER TYPE organization_type RENAME TO org_type;
    ALTER_SQL
  end
end
