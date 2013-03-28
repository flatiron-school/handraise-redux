class AddColumnLoginNameToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :login_name, :string
  end
end
