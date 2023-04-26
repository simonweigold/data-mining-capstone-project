library(rio)
library(here)
library(lubridate)

# Import data
# News headlines with SA scores
VADER <- import(here::here("ga_clean_VADER.csv"))
VADER$date <- as.Date(VADER$web_publication_date)
# Stock data
stock <- import(here::here("amzn.csv"))
