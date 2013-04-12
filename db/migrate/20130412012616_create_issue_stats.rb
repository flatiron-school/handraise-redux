class CreateIssueStats < ActiveRecord::Migration
  def change
    create_table :issue_stats do |t|
      t.integer :issue_id
      t.integer :status
      t.integer :wait_time

      t.timestamps
    end
  end
end
