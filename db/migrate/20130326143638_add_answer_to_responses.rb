class AddAnswerToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :answer, :boolean
  end
end
