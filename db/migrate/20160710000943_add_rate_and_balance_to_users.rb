class AddRateAndBalanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rate, :decimal
    add_column :users, :balance, :decimal
  end
end
