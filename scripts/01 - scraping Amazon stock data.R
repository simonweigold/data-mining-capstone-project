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



