import pandas as pd
from bs4 import BeautifulSoup, MarkupResemblesLocatorWarning
import warnings

# Read the CSV file
df = pd.read_csv('shrinked_lv.csv')

# Function to remove HTML tags

def remove_html_tags(text):
    if isinstance(text, str):
        with warnings.catch_warnings():
            warnings.filterwarnings("ignore", category=MarkupResemblesLocatorWarning)
            soup = BeautifulSoup(text, "html.parser")
        return soup.get_text()
    return text


# Apply the function to every column
for column in df.columns:
    df[column] = df[column].apply(remove_html_tags)

# Save the cleaned DataFrame to a new CSV file
df.to_csv('lv_striped.csv', index=False)

