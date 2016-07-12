class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.datetime :start_time
      t.datetime :end_time
      t.string :location
      t.decimal :rate

      t.timestamps null: false
    end
  end
end
