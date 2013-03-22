class AddAssigneeIdToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :assignee_id, :integer
  end
end
