class AddColumnGistIdToIssuesTable < ActiveRecord::Migration
  def change
    add_column :issues, :gist_id, :string
  end
end
