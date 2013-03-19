class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :role

  has_many :issues
end
