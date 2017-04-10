class RemoveRecipientEmailFromAuthToken < ActiveRecord::Migration
  def change
    remove_column :auth_tokens, :recipient_email, :string
  end
end
