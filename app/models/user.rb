class User < ActiveRecord::Base
  
  attr_accessible :email, :name, :username, :password, :portfolios
  
  has_many :portfolios
  has_many :stocks, :through => :portfolios
  
  has_secure_password
  
  validates :email, presence: true, uniqueness:true
  validates :password, presence: true, length: {in: 6..20}

  def clear_portfolios
    self.portfolios.each {|portfolio| portfolio.destroy}
  end
  
end
