class AddColumnOnCallToUsers < ActiveRecord::Migration
  def change
    add_column :users, :on_call, :boolean
  end
end
