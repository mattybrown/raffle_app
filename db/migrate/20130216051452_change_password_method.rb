class ChangePasswordMethod < ActiveRecord::Migration
  def up
    change_table :users do |t|
	t.string :password_digest
	remove_column :users, :encrypted_password
	remove_column :users, :salt
    end
  end

  def down
  end
end
