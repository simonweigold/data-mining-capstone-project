library(tidyverse)
library(rio)
library(jsonlite)
library(httr)
library(here)
setwd(here::here())
library(rstudioapi)

# Set API key and request URL
api_key <- rstudioapi::askForPassword()
request_url <- str_c("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=",
                     "AMZN",
                     "&outputsize=full&apikey=",
                     api_key)

# Request data from API
amzn_get <- httr::GET(request_url)
amzn_content <- httr::content(amzn_json)

# Extract data
close_data <- vector(mode = "list", length = length(amzn_content$`Time Series (Daily)`))
date <- vector(mode = "list", length = length(amzn_content$`Time Series (Daily)`))
for (i in 1:length(close_data)) {
  close_data[i] <- amzn_content$`Time Series (Daily)`[[i]]$`4. close`
  date[i] <- names(amzn_content$`Time Series (Daily)`[i])
}

# Convert to data frame
amzn <- as.data.frame(t(rbind(date, close_data)))