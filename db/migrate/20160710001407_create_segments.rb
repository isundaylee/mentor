class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.integer :user_id
      t.integer :owner_id
      t.date :date
      t.integer :st
      t.integer :ed

      t.timestamps null: false
    end
  end
end
