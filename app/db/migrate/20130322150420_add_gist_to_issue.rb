class AddGistToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :relevant_gist, :string
  end
end
