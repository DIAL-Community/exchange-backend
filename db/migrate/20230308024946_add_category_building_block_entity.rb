# frozen_string_literal: true

class AddCategoryBuildingBlockEntity < ActiveRecord::Migration[6.1]
  def up
    execute(<<-ALTER_SQL)
      CREATE TYPE category_type AS ENUM (
        'DPI',
        'FUNCTIONAL'
      );
    ALTER_SQL
    add_column(:building_blocks, :category, :category_type, null: true)
  end

  def down
    drop_column(:building_blocks, :category)
    execute(<<-ALTER_SQL)
      DROP TYPE category_type;
    ALTER_SQL
  end
end
