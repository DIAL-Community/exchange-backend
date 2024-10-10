# frozen_string_literal: true

class AddMaturityScoreToCandidateProducts < ActiveRecord::Migration[7.0]
  def change
    add_column(:candidate_products, :maturity_score, :jsonb, default: {})

    create_table(:candidate_product_category_indicators) do |t|
      t.references(
        :candidate_product,
        null: false,
        index: false,
        foreign_key: {
          to_table: :candidate_products,
          name: 'candidate_products_category_indicators_candidate_product_fk'
        }
      )
      t.references(
        :category_indicator,
        null: false,
        index: false,
        foreign_key: {
          to_table: :category_indicators,
          name: 'candidate_products_category_indicators_category_indicator_fk'
        }
      )
      t.string(:indicator_value, null: false)
      t.timestamps
      t.index(
        [:candidate_product_id, :category_indicator_id],
        unique: true,
        name: 'candidate_product_category_indicator_main_index'
      )
      t.index(
        [:category_indicator_id, :candidate_product_id],
        unique: true,
        name: 'candidate_product_category_indicator_reverse_index'
      )
    end
  end
end
