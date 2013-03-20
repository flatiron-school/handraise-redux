class ChangePasswordColumnToPasswordDigest < ActiveRecord::Migration
  def up
    rename_column :users, :password, :password_digest
  end

  def down
    rename_column :users, :password_digest, :password
  end
end
