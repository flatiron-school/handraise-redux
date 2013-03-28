class AddAnswerToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :answer, :integer
  end
end
