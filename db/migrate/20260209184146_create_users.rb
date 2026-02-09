class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      # Basic info
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false

      # Client relationship
      t.references :client, null: true, foreign_key: true

      # Email/Password authentication
      t.string :password_hash
      t.string :password_salt

      # Password reset
      t.string :password_reset_key
      t.datetime :password_reset_sent_at

      # API key for user identification
      t.string :apikey, null: false

      # User status (ACTIVE, INACTIVE, PENDING, BANNED)
      t.string :status, default: 'ACTIVE'

      # User role (member, admin, super_admin)
      t.string :role, default: 'member'

      # OAuth fields
      t.string :provider      # OAuth provider (Google, Apple, Facebook, etc.)
      t.string :oauth_sub     # OAuth subject ID

      # JWT session management
      t.text :jwt
      t.boolean :signed_in, default: false

      # Soft delete fields
      t.datetime :deleted_at
      t.bigint :deleted_by_id

      t.timestamps
    end

    # Indexes for fast lookups
    add_index :users, :email, unique: true
    add_index :users, :apikey, unique: true
    add_index :users, :password_reset_key
    add_index :users, :status
    add_index :users, :role
    add_index :users, :oauth_sub
    add_index :users, :deleted_at
  end
end
