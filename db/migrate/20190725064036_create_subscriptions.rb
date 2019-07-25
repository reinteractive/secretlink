class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :code
      t.integer :status
      t.json :cached_metadata
      t.json :cached_transaction_details

      t.timestamps null: false
    end
  end
end
