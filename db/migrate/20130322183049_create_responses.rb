class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :user_id
      t.integer :issue_id
      t.text :content
      t.timestamps
    end
  end
end
