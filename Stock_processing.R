R packages to download stock price data


# There are several ways to get financial data into R. The most popular method is the quantmod package. 
# You can install it by typing the command install.packages("quantmod") in your R console. 
# The prices downloaded in by using quantmod are xts zoo objects. 
# For our calculations we will use tidyquant package which downloads prices in a tidy format as a tibble. 
# You can download the tidyquant package by typing install.packages("tidyquant") in you R console. 
# tidyquant includes quantmod so you can install just tidyquant and get the quantmod packages as well.

library(tidyquant)


# First we will download Apple price using quantmod from January 2017 to February 2018. 
# By default quantmod download and stores the symbols with their own names. 
# You can change this by passing the argument auto.assign = FALSE.

options("getSymbols.warning4.0"=FALSE)
options("getSymbols.yahoo.warning"=FALSE)
# Downloading Apple price using quantmod

getSymbols("AAPL", from = '2017-01-01',
           to = "2018-03-01",warnings = FALSE,
           auto.assign = TRUE)
head(AAPL)
class(AAPL) # Lets look at the class of this object.

# As we mentioned before this is an xts zoo object. We can also chart the Apple stock price. We just pass the command chart_Series
chart_Series(AAPL)
# We can even zoom into a certain period of the series. Lets zoom in on the Dec to Feb period.
chart_Series(AAPL['2017-12/2018-03'])

# We can download prices for several stocks. There are several steps to this
tickers = c("AAPL", "NFLX", "AMZN", "K", "O")

getSymbols(tickers,
           from = "2017-01-01",
           to = "2017-01-15")

prices <- map(tickers,function(x) Ad(get(x)))
prices <- reduce(prices,merge)
colnames(prices) <- tickers
head(prices)
class(prices)

# But we prefer the tidyquant package to download stock prices. Below we will demonstrate the simplicity of the process.
aapl <- tq_get('AAPL',
               from = "2017-01-01",
               to = "2018-03-01",
               get = "stock.prices")
head(aapl)
class(aapl)

# We can see that the object aapl is a tibble. Next we can chart the price for Apple. For that we will use the very popular ggplot2 package.
aapl %>%
  ggplot(aes(x = date, y = adjusted)) +
  geom_line() +
  theme_classic() +
  labs(x = 'Date',
       y = "Adjusted Price",
       title = "Apple price chart") +
  scale_y_continuous(breaks = seq(0,300,10))

 # We can also download multiple stock prices.
 tickers = c("AAPL", "NFLX", "AMZN", "K", "O")

prices <- tq_get(tickers,
                 from = "2017-01-01",
                 to = "2017-03-01",
                 get = "stock.prices")

head(prices)
prices %>%
  group_by(symbol) %>%
  slice(1)

# We can also chart the time series of all the prices.
prices %>%
  ggplot(aes(x = date, y = adjusted, color = symbol)) +
  geom_line()

# This chart look weird, since the scale is not appropriate. Amazon price is above $800, other stocks are under $200. We can fix this with facet_wrap
prices %>%
  ggplot(aes(x = date, y = adjusted, color = symbol)) +
  geom_line() +
  facet_wrap(~symbol,scales = 'free_y') +
  theme_classic() +
  labs(x = 'Date',
       y = "Adjusted Price",
       title = "Price Chart") +
  scale_x_date(date_breaks = "month",
               date_labels = "%b\n%y")
