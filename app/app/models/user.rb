class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :role
  has_many :issues

  has_secure_password
  validates :password, :presence => { :on => :create }


end
