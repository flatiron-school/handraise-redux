class Issue < ActiveRecord::Base
  attr_accessible :content, :status, :title, :user_id

  belongs_to :user

  STATUS_MAP = {
    0 => :closed,
    1 => :open,
    2 => :urgent
  }

  def current_status
    STATUS_MAP[self.status].to_s 
  end

  def self.status
    STATUS_MAP
  end

  def closed?
    Issue.find_by_status :status => 0
  end

  def is_closed?
    self.status == 0
  end

end
