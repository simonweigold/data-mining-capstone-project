library(tidyverse)
library(rio)
library(here)
library(lubridate)

# Import data
# News headlines with SA scores
VADER <- import(here::here("ga_clean_VADER.csv"))
VADER$date <- as.Date(VADER$web_publication_date)
# Stock data
stock <- import(here::here("amzn.csv"))

# Define custom theme
custom_theme <-   theme(axis.text = element_text(color="black", size=12, family="serif"),
                        axis.text.x = element_text(color="black", size=12, family="serif"),
                        axis.ticks.x = element_line(),
                        axis.ticks.y = element_line(),
                        axis.line.x = element_line(size=0.5, color="grey"),
                        axis.line.y = element_line(size=0.5, color="grey"),
                        panel.grid = element_line(color = "honeydew2",
                                                  size = 0.5,
                                                  linetype = 1),
                        panel.background = element_rect(fill="white"),
                        plot.margin = margin(10,10,10,10),
                        plot.title = element_text(color="black", size=16, family="serif"),
                        plot.subtitle = element_text(color="grey26", size=14, family="serif"),
                        legend.text = element_text(color="black", size=12, family="serif"),
                        text = element_text(color="black", size=14, family="serif")
)

# Average sentiment per day
# VADER data preparation
df_means_VADER <- VADER %>%
  group_by(date) %>%
  summarize(mean_compound = mean(compound))

# VADER visualisation over time
df_means_VADER %>% 
  ggplot() +
  geom_point(aes(x=date, y=mean_compound), col="dodgerblue4") +
  xlab("Date") +
  ylab("Sentiment") +
  scale_x_date(date_minor_breaks = "1 day") +
  custom_theme

# Correct stock data for stock split in June 2022
stock$value <- stock$close_data
stock$value[stock$date > '2022-06-03'] <- stock$value*20

# Visualisation of stock data over time
stock %>% 
  ggplot() +
  geom_line(aes(x=date, y=value), col="dodgerblue4") +
  xlab("Date") +
  ylab("Value") +
  scale_x_date(date_minor_breaks = "1 day") +
  custom_theme

# Merge stock values and sentiment scores for dates
# Create stock df for merging
stock_join <- stock %>%
  filter(date >= '2000-01-01' & date <= '2022-12-31') %>%
  select(date, value)
# Set variable "date" to same type for both dfs
df_means_VADER$date <- as.Date(df_means_VADER$date)
stock_join$date <- as.Date(stock_join$date)
# Create df
df <- right_join(df_means_VADER, stock_join)

# Visualisation of stock and sentiment data over time
df %>% 
  ggplot() +
  geom_line(aes(x=date, y=mean_compound), col="dodgerblue") +
  geom_line(aes(x=date, y=value/max(value)), col="dodgerblue4") +
  xlab("Date") +
  ylab("Value") +
  scale_x_date(date_minor_breaks = "1 day") +
  custom_theme

# Calculate correlation between stock value and sentiment score
cor.test(df$mean_compound, df$value, use="complete.obs")

plot(df$mean_compound, df$value)
