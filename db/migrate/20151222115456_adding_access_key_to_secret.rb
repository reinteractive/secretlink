class AddingAccessKeyToSecret < ActiveRecord::Migration
  def change
    add_column :secrets, :access_key, :string
  end
end
