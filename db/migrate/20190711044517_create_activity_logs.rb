class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.string :key
      t.references :owner, polymorphic: true, index: true
      t.references :trackable, polymorphic: true, index: true
      t.references :recipient, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
