class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :role
  has_many :issues

  has_secure_password
  validates :password, :presence => { :on => :create }

  USER_ROLES = {
    :admin => 0,
    :student => 10
  }

  def set_as_admin 
    self.role = USER_ROLES[:admin]
  end

  def set_as_student 
    self.role = USER_ROLES[:student]
  end

  def admin?
    true if self.role_name == :admin
  end

  def self.user_roles
    USER_ROLES
  end

  def role_name
    User.user_roles.key(self.role)
  end

  def can_edit?(issue)
    true if (self.role == USER_ROLES[:admin] || issue.user_id == self.id)
  end

  def can_destroy?(issue)
    true if (self.role == USER_ROLES[:admin] || issue.user_id == self.id)
  end

  def can_resolve?(issue)
    true if (self.role == USER_ROLES[:admin] || issue.user_id == self.id)
  end

  def can_assign?(issue)
    true if Issue.not_closed.collect { |i| i.assignee_id }.include?(self.id) == false
  end

  def can_unassign?(issue)
    true if issue.assignee_id == self.id
  end

  # def can?(issue, action)
  #   true if (self.role == USER_ROLES[:admin] || issue.user_id == self.id)
  # end

  # current_user.can?(edit, object)

end
