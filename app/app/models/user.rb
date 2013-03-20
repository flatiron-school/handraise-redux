class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :role
  has_many :issues

  has_secure_password
  validates :password, :presence => { :on => :create }

  USER_ROLES = {
    0 => :admin,
    10 => :student
  }

  def self.user_roles
    USER_ROLES
  end

  def self.authenticate(email, password)
    user = User.find_by_email(email)
    if user.authenticate(password)
      user
    else
      false
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end    
  end

  def can_edit?(issue)
    true if (self.role == 0 || issue.user_id == self.id)
  end

  def can_destroy?(issue)
    true if (self.role == 0 || issue.user_id == self.id)
  end

  # def can?(issue, action)
  #   true if (self.role == 0 || issue.user_id == self.id)
  # end

  # current_user.can?(edit, object)

end
