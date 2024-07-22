# frozen_string_literal: true
class AddCategoriesFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table(:software_categories) do |t|
      t.string(:name, null: false)
      t.string(:slug, unique: true, null: false)

      t.string(:description, null: false)

      t.timestamps
    end

    create_table(:software_features) do |t|
      t.string(:name, null: false)
      t.string(:slug, unique: true, null: false)

      t.string(:description, null: false)
      t.integer(:facility_scale, null: true)

      t.references(:software_category, index: true, foreign_key: { to_table: :software_categories })

      t.timestamps
    end

    create_table(:product_categories, id: false, force: :cascade) do |t|
      t.references(:product, index: true, foreign_key: true)
      t.references(:software_category, index: true, foreign_key: true)
    end

    create_table(:product_features, id: false, force: :cascade) do |t|
      t.references(:product, index: true, foreign_key: true)
      t.references(:software_feature, index: true, foreign_key: true)
    end

    add_column(:products, :product_stage, :string, null: true)
  end
end
