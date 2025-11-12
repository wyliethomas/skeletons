class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string      :first_name
      t.string      :last_name
      t.string      :email
      t.string      :mobile
      t.string      :oauth_sub
      t.string      :jwt
      t.boolean     :signed_in
      t.string      :provider
      t.string      :password_hash
      t.string      :password_salt
      t.string      :password_reset_key
      t.string      :password_reset_code
      t.datetime    :password_reset_expires
      t.datetime    :last_active,             default: -> { 'CURRENT_TIMESTAMP' }
      t.string      :role
      t.string      :shirt_size
      t.string      :address1
      t.string      :address2
      t.string      :city
      t.string      :state
      t.string      :postal
      t.string      :apikey
      t.string      :status

      t.timestamps
      t.index :email, unique: true
      t.index :jwt
      t.index :apikey, unique: true
    end
  end
end
