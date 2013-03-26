class Response < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :content, :issue, :user, :issue_id, :user_id
  belongs_to :issue
  belongs_to :user

  def toggle_answer
    if self.answer == nil
      self.answer = 1
    else
      self.answer = nil
    end
  end

end
