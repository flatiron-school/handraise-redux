class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :role
  has_many :issues

  has_secure_password
  validates :password, :presence => { :on => :create }

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

  def logged_in?
    true if self.id == session[:user_id]
  end

end
