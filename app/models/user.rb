class User < ActiveRecord::Base
  
  attr_accessible :email, :name, :username, :password

  has_many :portfolios
  has_many :stocks, :through => :portfolios

  has_secure_password

end
