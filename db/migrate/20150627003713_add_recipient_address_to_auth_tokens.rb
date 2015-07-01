class AddRecipientAddressToAuthTokens < ActiveRecord::Migration
  def change
    add_column :auth_tokens, :recipient_email, :string
  end
end
