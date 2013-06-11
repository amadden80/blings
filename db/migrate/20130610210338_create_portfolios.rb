class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string :name
      t.belongs_to :user

      t.timestamps
    end
  end
end
