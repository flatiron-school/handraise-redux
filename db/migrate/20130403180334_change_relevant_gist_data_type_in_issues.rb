class ChangeRelevantGistDataTypeInIssues < ActiveRecord::Migration
  def change
    change_column :issues, :relevant_gist, :text
  end
end
