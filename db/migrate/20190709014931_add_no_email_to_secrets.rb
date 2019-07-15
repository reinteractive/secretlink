class AddNoEmailToSecrets < ActiveRecord::Migration
  def change
    add_column :secrets, :no_email, :boolean
  end
end
