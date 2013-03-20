class Issue < ActiveRecord::Base
  attr_accessible :content, :status, :title, :user_id, :assignee_id

  belongs_to :user

  belongs_to :assignee, :class_name => "User", :foreign_key => :assignee_id

  STATUS_MAP = {
    0 => :closed,
    1 => :waiting_room,                # part of the waiting_room queue
    2 => :fellow_student,              # part of the fellow_student queue
    3 => :instructor_normal,           # part of the instructor queue
    4 => :instructor_urgent            # part of the instructor queue
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
    issues = Issue.arel_table # http://asciicasts.com/episodes/215-advanced-queries-in-rails-3
    Issue.where(issues[:status].not_eq(0))
  end

  def is_closed?
    self.status == 0
  end

  def self.waiting_room(user_id)
    Issue.where(:status => 1, :user_id => user_id)
  end

  def is_waiting_room?
    self.status == 1
  end

  def self.fellow_student
    Issue.where(:status => 2)
  end

  def is_fellow_student?
    self.status == 2
  end

  def self.instructor_normal
    Issue.where(:status => 3)
  end

  def is_instructor_normal?
    self.status == 3
  end

  def self.instructor_urgent
    Issue.where(:status => 4)
  end

  def is_instructor_urgent?
    self.status == 4
  end

  def self.timebased_status
    Issue.not_closed.each do |issue|
      case
      when issue.created_at < Time.now-10.minutes 
        issue.status = 4
        issue.save
      when issue.created_at < Time.now-3.minutes
        issue.status = 3
        issue.save 
      when issue.created_at < Time.now-1.minutes
        issue.status = 2
        issue.save
      end       
    end
  end

  def from_current_user
    self.user_id == @current_user.id    
  end  


end
