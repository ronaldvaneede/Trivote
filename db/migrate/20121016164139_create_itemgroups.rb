class CreateItemgroups < ActiveRecord::Migration
  def change
    create_table :itemgroups do |t|
      t.string :name

      t.timestamps
    end
  end
end
