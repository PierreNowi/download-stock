# Getting stock prices from Yahoo Finance

# There are many data providers, some are free most are paid. 
# In this chapter we will use the data from Yahoo’s finance website. 
# Since Yahoo was bought by Verizon, there have been several changes with their API. 
# They may decide to stop providing stock prices in the future. So the method discussed on this article may not work in the future.

# Python has a module called pandas-datareader which is used for downloading financial data from yahoo. 
# You can install it by typing the command pip install pandas-datareader in your terminal/command prompt 
# (update as of 2019 this is no longer true, use the fix-yahoo-finance module).

import pandas as pd
import pandas_datareader as web
import numpy as np
import matplotlib.pyplot as plplt

# We will download Apple stock’s price first.
aapl = web.get_data_yahoo("AAPL",
start = "2017-01-01",
end = "2018-03-01")

print(aapl.head())

# We can plot the data for Apple.
aapl["Adj Close"].plot()
plt.xlabel("Date")
plt.ylabel("Adjusted Price")
plt.title("Apple price data")
plt.show()

# We can also download the data for multiple stocks using the below command.
tickers = ["AAPL", "MSFT", "AMZN", "K", "O"]
prices = web.get_data_yahoo(tickers,
start = "2017-01-01",
end = "2017-01-15")

print(prices.head())
# We can also just look at the adjusted prices.
prices["Adj Close"].head()


#  installed pandas-datareader but I'm wondering if there are alternatives.
import pandas_datareader.data as web
start_date = '2018-01-01'
end_date = '2018-06-08'
panel_data = web.DataReader('SPY', 'yahoo', start_date, end_end_date

# Yahoo Finance is one of the free sources to get stock data. 
# You can get the data either using pandas datareader or can get using yfinance library. The method to get data from yfinance library is shown below.

import yfinance as yf
# Get the data of the stock AAPL
data = yf.download('AAPL','2016-01-01','2019-08-01')

# Wiki is one of the free source available on quandl to get the data for the 3000+ US equities. 
# This is a community maintained data. Recently it is stopped being maintained but however, it is a good free source to backtest your strategies. 
# To get the data, you need to get the free API key from quandl and replace the in the below code with your API key.

# Import the quandl package
import quandl
# Get the data from quandl
data = quandl.get("WIKI/KO", start_date="2016-01-01", end_date="2018-01-01", 
    api_key=<Your_API_Key>)

# Code is written in Python 2.7, but should work in 3.5 when you replace the print function. 
# Make sure when you copy the spacing is correct in your editor: a tab is 4 spaces etc.

# pip install datareader
import pandas as pd
pd.core.common.is_list_like = pd.api.types.is_list_like
import pandas_datareader.data as web
import matplotlib.pyplot as plt
import numpy as np

from datetime import datetime, timedelta

#stock of interest
stock=['MSFT','SAP','V','JPM']

# period of analysis
end = datetime.now()
start = end - timedelta(days=500)

for i in range(len(stock)):
    f = web.DataReader(stock[i], 'morningstar', start, end)

    # nice looking timeseries (DataFrame to panda Series)
    f = f.reset_index()
    f = pd.Series(f.Close.values,f.Date)

    print "Start: Year, Month, Day, Time"
    print str(start)
    f.plot(label=stock[i]);
    plt.legend()
    plt.ylabel('price in [USD]')

plt.show();

# You could also use quandl, but you have to sign up and get your own API key. Not sure if any of the free financial APIs 

# pip install datareader
import pandas as pd
pd.core.common.is_list_like = pd.api.types.is_list_like
# quandl api explore
import quandl
from datetime import datetime, timedelta
import matplotlib.pyplot as plt
# api instructions
quandl.ApiConfig.api_key = "YOUR_API_KEY"
end = datetime.now()
start = end - timedelta(days=365)
# frankfurt stock exchange
mydata2 = quandl.get('FSE/VOW3_X', start_date = start, end_date = end)
f = mydata2.reset_index()
# timeseries
plt.figure(1)
f = pd.Series(f.Close.values,f.Date)
f.plot()
plt.show()


#I found the easiest to be the new SimFin Python API which lets you download stock-prices and fundamental data, save it to disk,
# and load it into Pandas DataFrames with only a few lines of code. They have also made several tutorials on how to use their data with other 
#libraries such as statsmodels, scikit-learn, TensorFlow, etc. The basic example below is copied from their github page.

# You install the SimFin python package by typing this command in a terminal window (preferably in its own environement, see their full instructions):

pip install simfin
import simfin as sf
from simfin.names import *

# Set your API-key for downloading data.
# If the API-key is 'free' then you will get the free data,
# otherwise you will get the data you have paid for.
# See www.simfin.com for what data is free and how to buy more.
sf.set_api_key('free')

# Set the local directory where data-files are stored.
# The dir will be created if it does not already exist.
sf.set_data_dir('~/simfin_data/')

# Load the annual Income Statements for all companies in USA.
# The data is automatically downloaded if you don't have it already.
df = sf.load_income(variant='annual', market='us')

# Print all Revenue and Net Income for Microsoft (ticker MSFT).
print(df.loc['MSFT', [REVENUE, NET_INCOME]])

# We can also load the daily share-prices and plot the closing share-price for Microsoft (ticker MSFT):

# Load daily share-prices for all companies in USA.
# The data is automatically downloaded if you don't have it already.
df_prices = sf.load_shareprices(market='us', variant='daily')

# Plot the closing share-prices for ticker MSFT.
df_prices.loc['MSFT', CLOSE].plot(grid=True, figsize=(20,10), title='MSFT Close')

