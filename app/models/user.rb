class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :role, :profile_url, :responses, :cell, :on_call, :image, :image_file_name, :image_content_type
  has_attached_file :image, :default_url => "/assets/missing.png" 

  has_many :responses
  has_many :issues, :through => :responses

  has_many :votes
  has_many :issues, :through => :votes

  has_many :issues

  has_secure_password
  validates :password, :presence => { :on => :create }

  has_many :identities

  USER_ROLES = {
    :admin => 0,
    :student => 10
  }

  def currently_assigned_issue
    Issue.where(:assignee_id => self.id).first
  end

  def set_as_admin 
    self.role = USER_ROLES[:admin]
  end

  def set_as_student 
    self.role = USER_ROLES[:student]
  end

  def admin?
    true if self.role_name == :admin
  end

  def owns?(issue)
    true if self.id == issue.user_id
  end

  def self.admin
    User.where(:role => USER_ROLES[:admin])
  end

  def self.user_roles
    USER_ROLES
  end

  def on_call?
    true if self.on_call == true
  end

  def is_available?
    true if Issue.not_closed.find_by_assignee_id(self.id).nil? && self.on_call?
  end

  def role_name
    User.user_roles.key(self.role)
  end

  def can_edit?(issue)
    true if admin? || owns?(issue)
  end

  def can_destroy?(issue)
    true if admin? || owns?(issue)
  end

  def can_resolve?(issue)
    true if owns?(issue)
  end

  def can_assign?(issue)
    true if Issue.not_closed.collect { |i| i.assignee_id }.include?(self.id) == false
  end

  def can_unassign?(issue)
    true if issue.assignee_id == self.id || self.admin? || self.owns?(issue)
  end

  def can_mark_as_helped?(issue)
    true if issue.assignee_id == self.id || self.admin?
  end

  def can_upvote?(issue)
    true if issue.user_id != self.id && issue.votes.collect {|vote| vote.user_id}.include?(self.id) == false
  end

  def can_votedown?(issue)
    true if issue.votes.collect {|vote| vote.user_id}.include?(self.id) == true
  end

  def has_identity?(auth_provider)
    identity_array = self.identities.collect {|identity| identity.provider}
    identity_array.include?(auth_provider)
  end

  def has_cell?
    true unless self.cell == "" || self.cell.nil?
  end

  # def can?(issue, action)
  #   true if (self.role == USER_ROLES[:admin] || issue.user_id == self.id)
  # end

  # current_user.can?(edit, object)

  def self.create_from_hash(hash)
    create(:name => hash['info']['name'])
  end

  def can_edit_delete_profile?(user)
    true if self.id == user.id || self.admin?
  end

  def has_open_issue?
    true unless self.issues.not_closed.empty?
  end

end
