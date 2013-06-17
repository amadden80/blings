class Portfolio < ActiveRecord::Base
  attr_accessible :name, :user_id, :stocks

  belongs_to :user
  has_and_belongs_to_many :stocks
  
  validates :name, presence: true
end
