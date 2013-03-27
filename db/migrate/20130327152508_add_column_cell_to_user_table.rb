class AddColumnCellToUserTable < ActiveRecord::Migration
  def up
    add_column :users, :cell, :string
  end

  def down
    remove_column :users, :cell, :string
  end
end