class Issue < ActiveRecord::Base
  attr_accessible :content, :status, :title, :user_id, :assignee_id, :relevant_gist, :responses, :aasm_state

  belongs_to :user

  belongs_to :assignee, :class_name => "User", :foreign_key => :assignee_id

  has_many :responses
  has_many :users, :through => :responses

  has_many :votes
  has_many :users, :through => :votes

  extend IssueStats

  include AASM

  aasm :whiny_transitions => false do
    state :waiting_room, :initial => true
    state :fellow_student
    state :instructor_normal
    state :instructor_urgent
    state :post_help
    state :closed

    # before triggering first event, issue.aasm_state will be empty. this method can be called to save issue.aasm_state to 'waiting_room'
    event :to_waiting_room do
      transitions :from => :waiting_room, :to => :waiting_room
    end

    event :to_fellow_student do
      transitions :from => [:closed, :waiting_room, :instructor_urgent, :post_help], :to => :fellow_student
    end

    event :to_instructor_normal do
      transitions :from => [:closed, :fellow_student, :instructor_urgent, :post_help], :to => :instructor_normal
    end

    event :to_instructor_urgent do
      transitions :from => [:closed, :fellow_student, :instructor_normal, :post_help], :to => :instructor_urgent
    end

    event :to_post_help do
      transitions :from => [:fellow_student, :instructor_normal, :instructor_urgent], :to => :post_help
    end

    event :to_closed do
      transitions :from => [:waiting_room, :fellow_student, :instructor_normal, :instructor_urgent, :post_help], :to => :closed
    end
  end


  def self.scopable_by(status_key, opts = {})
    define_singleton_method status_key do
      pre_scope = opts[:pre_scope] ? Issue.send(opts[:pre_scope]) : Issue
      pre_scope.where(:aasm_state => status_key.to_s)
    end

    define_method "is_#{status_key}?" do
      self.aasm_state == status_key.to_s
    end
  end

  scopable_by :closed
  scopable_by :fellow_student, :pre_scope => :not_assigned
  scopable_by :instructor_normal, :pre_scope => :not_assigned
  scopable_by :instructor_urgent, :pre_scope => :not_assigned
  scopable_by :post_help, :pre_scope => :not_assigned

  def self.waiting_room(user_id)
    Issue.where(:aasm_state => "waiting_room", :user_id => user_id)
  end

  def self.not_closed
    issues = Issue.arel_table # http://asciicasts.com/episodes/215-advanced-queries-in-rails-3
    Issue.where(issues[:aasm_state].not_eq("closed"))
  end

  def self.for_instructor
    issues = Issue.arel_table # http://asciicasts.com/episodes/215-advanced-queries-in-rails-3

    # # Filter for
    # only issues that are not closed
    # only issues that are not post_help
    filter_for_instructor = (issues[:aasm_state].not_eq("closed") and issues[:aasm_state].not_eq("post_help"))

    Issue.where(filter_for_instructor)
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
      self.to_instructor_urgent
    when self.created_at < Time.now-2.seconds
      self.to_instructor_normal
    when self.created_at < Time.now-1.seconds
      self.to_fellow_student
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
    client = self.github_user(current_user)
    gist_hash = client.create_gist({:public => true, :files => {"#{self.title}.txt" => {:content => new_gist}}})    
    save_gist_id(gist_hash)
  end

  def edit_github_gist(gist, current_user)
    client = self.github_user(current_user)
    gist_hash = client.edit_gist(self.gist_id, {:files => {"#{self.title}.txt" => {:content => gist}}})    
  end

  def github_user(current_user)
    user_login_name = current_user.identities.first.login_name
    user_oauth_token = current_user.identities.first.token
    Octokit::Client.new(:login => user_login_name, :oauth_token => user_oauth_token)
  end

  def save_gist_id(gist_hash)
    self.gist_id = gist_hash[:id]
    self.save
  end
end

