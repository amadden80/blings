class User < ActiveRecord::Base
  
  attr_accessible :email, :name, :username, :password, :portfolios

  has_many :portfolios
  has_many :stocks, :through => :portfolios

  has_secure_password

end
