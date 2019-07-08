class AddExtendedAtToSecret < ActiveRecord::Migration
  def change
    add_column :secrets, :extended_at, :datetime
  end
end
