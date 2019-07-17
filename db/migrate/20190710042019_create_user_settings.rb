class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.text :send_secret_email_template
      t.belongs_to :user, index: true, foreign_key: true
    end
  end
end
