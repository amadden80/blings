class Stock < ActiveRecord::Base
  attr_accessible :name, :ticker

  has_many :portfolios
  has_many :users, :through => :portfolios

end
