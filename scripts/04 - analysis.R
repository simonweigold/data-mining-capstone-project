library(rio)
library(here)
library(lubridate)

# Import data
# News headlines with SA scores
VADER <- import(here::here("ga_clean_VADER.csv"))
VADER$date <- as.Date(VADER$web_publication_date)
# Stock data
stock <- import(here::here("amzn.csv"))

# Average sentiment per day
# VADER data preparation
df_means_VADER <- VADER %>%
  group_by(date) %>%
  summarize(mean_compound = mean(compound))

# VADER visualisation
df_means_VADER %>% 
  ggplot() +
  geom_line(aes(x=date, y=mean_compound), col="dodgerblue4") +
  xlab("Date") +
  ylab("Sentiment") +
  scale_x_date(date_minor_breaks = "1 day") +
  theme(axis.text = element_text(color="black", size=12, family="serif"),
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
