class Issue < ActiveRecord::Base
  include AASM

  aasm :whiny_transitions => false do
    state :waiting_room, :initial => true
    state :fellow_student
    state :instructor_normal
    state :instructor_urgent
    state :closed

    # before triggering first event, issue.aasm_state will be empty. this method can be called to save issue.aasm_state to 'waiting_room'
    event :to_waiting_room do
      transitions :from => :waiting_room, :to => :waiting_room
    end

    event :to_fellow_student do
      transitions :from => [:waiting_room, :instructor_urgent], :to => :fellow_student
    end

    event :to_instructor_normal do
      transitions :from => [:fellow_student, :instructor_urgent], :to => :instructor_normal
    end

    event :to_instructor_urgent do
      transitions :from => [:fellow_student, :instructor_normal], :to => :instructor_urgent
    end

    event :to_closed do
      transitions :from => [:waiting_room, :fellow_student, :instructor_normal, :instructor_urgent], :to => :closed
    end

  end


  attr_accessible :content, :status, :title, :user_id, :assignee_id, :relevant_gist, :responses, :aasm_state

  belongs_to :user

  belongs_to :assignee, :class_name => "User", :foreign_key => :assignee_id

  has_many :responses
  has_many :users, :through => :responses

  has_many :votes
  has_many :users, :through => :votes

  extend IssueStats

  STATUS_MAP = {
    :closed => 0,
    :waiting_room => 1,                # part of the waiting_room queue
    :fellow_student => 2,              # part of the fellow_student queue
    :instructor_normal => 3,           # part of the instructor queue
    :instructor_urgent => 4            # part of the instructor queue
  }

  def self.scopable_by(status_key, opts = {})
    define_singleton_method status_key do
      pre_scope = opts[:pre_scope] ? Issue.send(opts[:pre_scope]) : Issue
      pre_scope.where(:status => Issue::STATUS_MAP[status_key])
    end

    define_method "is_#{status_key}?" do
      self.status == Issue::STATUS_MAP[status_key]
    end
  end

  scopable_by :closed
  scopable_by :fellow_student, :pre_scope => :not_assigned
  scopable_by :instructor_normal, :pre_scope => :not_assigned
  scopable_by :instructor_urgent, :pre_scope => :not_assigned

  def self.waiting_room(user_id)
    Issue.where(:status => Issue::STATUS_MAP[:waiting_room], :user_id => user_id)
  end

  def is_waiting_room?
    self.status == Issue::STATUS_MAP[:waiting_room]
  end

  def current_status
    Issue.status.key(self.status).to_s 
  end

  def self.status
    STATUS_MAP
  end

  def self.not_closed
    issues = Issue.arel_table # http://asciicasts.com/episodes/215-advanced-queries-in-rails-3
    Issue.where(issues[:status].not_eq(STATUS_MAP[:closed]))
  end

  def self.for_instructor
    issues = Issue.arel_table # http://asciicasts.com/episodes/215-advanced-queries-in-rails-3

    # # Filter for
    # only closed issues
    # only issues that are in states instructor urgent or normal
    # only issues that are not assigned
    filter_for_instructor = (issues[:status].not_eq(Issue::STATUS_MAP[:closed]) and (issues[:status].eq(Issue::STATUS_MAP[:instructor_urgent]) or issues[:status].eq(Issue::STATUS_MAP[:instructor_normal])) and issues[:assignee_id].eq(nil))

    Issue.where(filter_for_instructor).first
  end

  def is_assigned?
    true unless self.assignee_id.nil?
  end

  def is_unassigned?
    self.assignee_id.nil?
  end

  def status_change
    case
    when self.created_at < Time.now-40.minutes 
      self.status = STATUS_MAP[:instructor_urgent]
    when self.created_at < Time.now-20.minutes
      self.status = STATUS_MAP[:instructor_normal]
    when self.created_at < Time.now-5.minutes
      self.status = STATUS_MAP[:fellow_student]
    end    
  end

  def from_current_user
    self.user_id == @current_user.id    
  end  

  def assigned_to
    User.find_by_id(self.assignee_id).name
  end

  def self.assigned
    Issue.not_closed.where("assignee_id >= ?", 0)
  end

  def self.not_assigned
    Issue.not_closed.where("assignee_id IS NULL")
  end

  def answered?
    true unless self.responses.where(:answer => 1).empty?
  end

  def asker?(user)
    true if self.user == user
  end

  def voted_on?(user)
    vote_user_id_array = self.votes.collect {|vote| vote.user_id}
    vote_user_id_array.include?(user.id)
  end

  def send_to_github(new_gist, current_user)
    user_login_name = current_user.identities.first.login_name
    user_oauth_token = current_user.identities.first.token
    client = Octokit::Client.new(:login => user_login_name, :oauth_token => user_oauth_token)
    gist_hash = client.create_gist({:public => true, :files => {"#{self.title}.txt" => {:content => new_gist}}})    
    save_gist_id(gist_hash)
  end

  def save_gist_id(gist_hash)
    self.gist_id = gist_hash[:id]
    self.save
  end
end
