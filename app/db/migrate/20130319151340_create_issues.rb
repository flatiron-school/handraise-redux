class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.text :content
      t.string :title
      t.integer :user_id
      t.integer :status

      t.timestamps
    end
  end
end
