class CreatePortfoliosStocksTable < ActiveRecord::Migration
  def change
    create_table :portfolios_stocks, :id => false do |t|
      t.integer :stock_id
      t.integer :porfolio_id
    end
  end
end
