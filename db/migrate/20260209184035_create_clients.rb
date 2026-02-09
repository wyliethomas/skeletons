class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :urlkey, null: false

      # Soft delete fields
      t.datetime :deleted_at
      t.bigint :deleted_by_id

      t.timestamps
    end

    add_index :clients, :urlkey, unique: true
    add_index :clients, :deleted_at
    add_index :clients, :created_at
  end
end
