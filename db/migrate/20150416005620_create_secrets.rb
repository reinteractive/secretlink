class CreateSecrets < ActiveRecord::Migration
  def change
    create_table :secrets do |t|
      t.string :title
      t.string :from_email, required: true
      t.string :to_email, required: true
      t.text :encrypted_secret
      t.string :encrypted_secret_salt
      t.string :encrypted_secret_iv
      t.string :uuid
      t.text :comments
      t.datetime :expire_at
      t.datetime :consumed_at
      t.string :secret_file

      t.timestamps null: false
    end
  end
end
