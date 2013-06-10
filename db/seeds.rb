

# Blank that slate!
User.delete_all
Portfolio.delete_all
Stock.delete_all

# Define options for objects
userNames = [
  'David',
  'Andrew',
  'George']

portfolioNames = [
  'Money1',
  'Money2', 
  'Money3', 
  'Money4']

stockTickers = [
  'AAPL',
  'GE',
  'MSFT',
  'PFE' ]


# Insert into Database new objects!
user_array = userNames.map {|name| User.create(name: name)}
portfolio_array = portfolioNames.map {|name| Portfolio.create(name: name)}
stock_array = stockTickers.map {|ticker| Stock.create(ticker: ticker)}


# Related 'dem objects
portfolio_array[0].stocks << stock_array[0]
portfolio_array[0].stocks << stock_array[2]
portfolio_array[0].stocks << stock_array[1]
portfolio_array[1].stocks << stock_array[1]
portfolio_array[2].stocks << stock_array[2]

user_array[0].portfolios << portfolio_array[0] << portfolio_array[3]
user_array[1].portfolios << portfolio_array[1]
user_array[2].portfolios << portfolio_array[2]
