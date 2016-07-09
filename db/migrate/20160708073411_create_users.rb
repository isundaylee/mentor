class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :oauth_token
      t.string :avatar_url
      t.datetime :oauth_token_expires_at

      t.timestamps null: false
    end
  end
end
