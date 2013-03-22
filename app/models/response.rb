class Response < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :content, :issue, :user, :issue_id, :user_id
  belongs_to :issue
  belongs_to :user

  
end
