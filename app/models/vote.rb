class Vote < ActiveRecord::Base
  attr_accessible :issue_id, :user_id

  belongs_to :issue
  belongs_to :user
end
