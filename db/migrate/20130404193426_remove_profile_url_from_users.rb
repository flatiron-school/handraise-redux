class RemoveProfileUrlFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :profile_url
  end

  def down
    add_column :users, :profile_url, :string
  end
end
