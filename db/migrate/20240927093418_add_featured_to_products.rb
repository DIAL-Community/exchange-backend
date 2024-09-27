class AddFeaturedToProducts < ActiveRecord::Migration[7.0]
  def up
    add_column :products, :featured, :boolean, default: false
  end

  def down
    remove_column :products, :featured
  end
end
