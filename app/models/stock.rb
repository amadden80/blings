class Stock < ActiveRecord::Base
  attr_accessible :num_called, :ticker
  after_initialize :default_values

  private
    def default_values
      self.num_called ||= 0
    end
end

