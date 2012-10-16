class AddItemgroupToItem < ActiveRecord::Migration
  def change
    add_column :items, :itemgroup_id, :integer
    add_index :items, :itemgroup_id
  end
end