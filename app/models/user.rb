class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :username

  has_many :portfolios
  has_many :stocks, :through => :portfolios
end
