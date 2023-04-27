import os
import nltk
nltk.download('vader_lexicon')
from nltk.sentiment.vader import SentimentIntensityAnalyzer
import pandas as pd

sid = SentimentIntensityAnalyzer()

# Import data
df = pd.read_csv(os.path.join(os.getcwd(), "ga_clean.csv"))

# Calculate scores
df['scores'] = df['headline'].apply(lambda review: sid.polarity_scores(review))

df['compound']  = df['scores'].apply(lambda score_dict: score_dict['compound'])

def categorize(value):
    if value >= 0.05:
        return 'pos'
    elif value <= -0.05:
        return 'neg'
    else:
        return 'neu'
df['comp_score'] = df['compound'].apply(categorize)

# Show head of results
print(df.head())

# Export csv
df.to_csv(os.path.join(os.getcwd(), "ga_clean_VADER.csv"), index = False)
