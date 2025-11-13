# frozen_string_literal: true

# Migration to create users table with authentication fields
#
# This migration creates the users table with support for:
# - Email/password authentication
# - Google OAuth
# - JWT tokens
# - Password reset
# - User status management
#
# To use:
#   Copy this file to db/migrate/ with a timestamp prefix:
#   cp create_users.rb db/migrate/20250101000000_create_users.rb
#
#   Then run: rails db:migrate
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      # Basic info
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false

      # Email/Password authentication
      t.string :password_hash
      t.string :password_salt

      # Password reset
      t.string :password_reset_key

      # API key for user identification
      t.string :apikey, null: false

      # User status (ACTIVE, INACTIVE, PENDING, BANNED)
      t.string :status, default: 'ACTIVE'

      # OAuth fields
      t.string :provider      # OAuth provider (Google, Apple, Facebook, etc.)
      t.string :oauth_sub     # OAuth subject ID

      # JWT session management
      t.text :jwt
      t.boolean :signed_in, default: false

      t.timestamps
    end

    # Indexes for fast lookups
    add_index :users, :email, unique: true
    add_index :users, :apikey, unique: true
    add_index :users, :password_reset_key
    add_index :users, :status
    add_index :users, :oauth_sub
  end
end
