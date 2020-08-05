# Import stock price from Yahoo Finance into R

# function in quantmod that does what Dirk has done by hand. See getQuote() and yahooQF(). 
# Typing yahooQF() will bring up a menu of all the possible quote formats you can use.

require(quantmod)
getQuote("QQQQ;SPY", what=yahooQF("Last Trade (Price Only)"))

# That is pretty easy given that R can read directly off a given URL. 
# The key is simply to know how to form the URL. 
# Here is a quick and dirty example based on code Dj Padzensky wrote in the late 1990s and which I have been maintaining 
# in the Perl module Yahoo-FinanceQuote (which is of course also on CPAN here) for almost as long.

syms <- c("^GSPC", "^IXIC")
baseURL <- "http://download.finance.yahoo.com/d/quotes.csvr?e=.csv&f="
formatURL <- "snl1d1t1c1p2va2bapomwerr1dyj1x"
endURL <- "&s="
url <- paste(baseURL, formatURL, endURL, paste(syms, collapse="+"), sep="")
read.csv(url, header=FALSE)

# gather and chart "pseudo-real time" data from yahoo:
require(quantmod)
Times <-  NULL
Prices <- NULL
while(1) {

   tryCatch({
      #Load current quote
      Year <- 1970
      currentYear <- as.numeric(format(Sys.time(),'%Y'))
      while (Year != currentYear) { #Sometimes yahoo returns bad quotes
         currentQuote <- getQuote('SPY')
         Year <- as.numeric(format(currentQuote['Trade Time'],'%Y'))
      }

      #Add current quote to the dataset
      if (is.null(Times)) {
         Times <- Sys.time()-15*60 #Quotes are delayed 15 minutes
         Prices <- currentQuote['Last']
      } else {
         Times <- c(Times,Sys.time())
         Prices <- rbind(Prices,currentQuote['Last'])
      } 

      #Convert to 1-minute bars
      Data <- xts(Prices,order.by=Times)
      Data <- na.omit(to.minutes(Data,indexAt='endof'))

      #Plot the data when we have enough
      if (nrow(Data)>5) { 
         chartSeries(Data,theme='white',TA='addRSI(n=5);addBBands(n=5)')
      }

      #Wait 1 second to avoid overwhelming the server
      Sys.sleep(1)

   #On errors, sleep 10 seconds and hope it goes away
   },error=function(e) {print(e);Sys.sleep(10)}) 
}

library(quantmod)
getSymbols("LT.NS",src="yahoo")