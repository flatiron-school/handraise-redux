class ChangeAnswerInResponses < ActiveRecord::Migration
  def up
    change_column :responses, :answer, :integer
  end

  def down
    change_column :responses, :answer, :boolean
  end
end
