class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
      t.string :email
      t.string :hashed_token
      t.datetime :expire_at

      t.timestamps null: false
    end
  end
end
