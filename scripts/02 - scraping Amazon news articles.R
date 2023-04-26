library(tidyverse)
library(here)
library(guardianapi)
library(rio)

# Data retrieval----
# Load API key
gu_api_key()

# GET request
api_request <- gu_content(query = "amazon",
                          from_date = "2000-01-01",
                          to_date = "2022-12-31")

# Save data as data frame
df <- api_request %>% select(-tags)
df <- as.data.frame(df)
write.csv(df, here::here("guardian_amazon.csv"))

# Data pre-processing----
# When already saved, import data
guardian_amazon <- import(here::here("guardian_amazon.csv"))

# Reduce data to minimum amount of variables
ga_clean <- guardian_amazon %>% 
  select(web_title, headline, web_publication_date, body_text)

# Introduce NAs
ga_clean$body_text[ga_clean$body_text == ""] <- "NA"

# Convert text to UTF-8
Encoding(ga_clean$body_text) <- "UTF-8"
Encoding(ga_clean$headline) <- "UTF-8"

# Save clean data
write.csv(ga_clean, here::here("ga_clean.csv"))
