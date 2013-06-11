class CreatePortfoliosStocksTable < ActiveRecord::Migration
  def change
    create_table :portfolios_stocks, :id => false do |t|
      .belongs_to :stock
      t.belongs_to :portfolio
    end
  end
end
