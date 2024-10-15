# frozen_string_literal: true

class AddApprovalStatusToProducts < ActiveRecord::Migration[7.0]
  def change
    add_reference(
      :products,
      :approval_status,
      foreign_key: {
        to_table: :candidate_statuses,
        on_delete: :nullify
      }
    )
  end
end
