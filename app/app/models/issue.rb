class Issue < ActiveRecord::Base
  attr_accessible :content, :status, :title, :user_id, :assignee_id

  belongs_to :user

  belongs_to :assignee, :class_name => "User", :foreign_key => :assignee_id

  STATUS_MAP = {
    0 => :closed,
    1 => :open,
    2 => :urgent,
    3 => :assigned
  }

  def current_status
    STATUS_MAP[self.status].to_s 
  end

  def self.status
    STATUS_MAP
  end

  def self.closed
    Issue.where(:status => 0)
  end

  def self.not_closed
    Issue.where(:status => 1 || 2)
  end

  def is_closed?
    self.status == 0
  end

  def self.open
    Issue.where(:status => 1)
  end

  def is_open?
    self.status == 1
  end

  def self.urgent
    Issue.where(:status => 2)
  end

  def is_urgent?
    self.status == 2
  end

  def self.recent
    Issue.not_closed.where('created_at > ?', Time.now-15.minutes)
  end

  def self.long_wait
    Issue.not_closed.where('created_at < ?', Time.now-1.hour)
  end

end
